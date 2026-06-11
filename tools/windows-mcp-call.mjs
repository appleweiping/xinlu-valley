import { spawn } from "node:child_process";
import { writeFile } from "node:fs/promises";

const [toolName, rawArgs = "{}", ...rest] = process.argv.slice(2);

if (!toolName) {
  console.error("Usage: node tools/windows-mcp-call.mjs <ToolName> <jsonArgs> [--image-out path]");
  process.exit(2);
}

let imageOut = null;
for (let i = 0; i < rest.length; i += 1) {
  if (rest[i] === "--image-out") {
    imageOut = rest[i + 1] ?? null;
    i += 1;
  }
}

let decodedArgs = rawArgs;
if (rawArgs.startsWith("base64:")) {
  decodedArgs = Buffer.from(rawArgs.slice("base64:".length), "base64").toString("utf8");
}

let toolArgs;
try {
  toolArgs = JSON.parse(decodedArgs);
} catch (error) {
  console.error(`Invalid JSON tool arguments: ${error.message}`);
  process.exit(2);
}

const windowsMcpExe =
  process.env.WINDOWS_MCP_EXE ??
  "D:\\devtools\\codex\\home\\mcp-servers\\windows-mcp\\.venv-py314\\Scripts\\windows-mcp.exe";

const child = spawn(
  windowsMcpExe,
  ["serve", "--transport", "stdio", "--tools", "Screenshot,Snapshot,Click,Move,Type,Shortcut,Wait,App"],
  {
    env: {
      ...process.env,
      ANONYMIZED_TELEMETRY: "false",
      WINDOWS_MCP_DISABLE_FLASH: "1",
      WINDOWS_MCP_SCREENSHOT_SCALE: "1.0",
    },
    windowsHide: true,
  },
);

let buffer = "";
let finished = false;

function send(message) {
  child.stdin.write(`${JSON.stringify(message)}\n`);
}

async function handleResult(result) {
  if (result?.isError) {
    throw new Error(JSON.stringify(result));
  }

  const textItems = [];
  let savedImage = false;
  for (const item of result?.content ?? []) {
    if (item.type === "text") {
      textItems.push(item.text);
    }
    if (!savedImage && imageOut && item.type === "image" && item.data) {
      await writeFile(imageOut, Buffer.from(item.data, "base64"));
      savedImage = true;
    }
  }

  if (imageOut && !savedImage) {
    throw new Error(`Tool ${toolName} did not return an image to save.`);
  }

  console.log(JSON.stringify({ tool: toolName, imageOut, text: textItems }, null, 2));
}

child.stdout.on("data", (data) => {
  buffer += data.toString();
  for (;;) {
    const newline = buffer.indexOf("\n");
    if (newline < 0) {
      break;
    }
    const line = buffer.slice(0, newline).trim();
    buffer = buffer.slice(newline + 1);
    if (!line) {
      continue;
    }

    let message;
    try {
      message = JSON.parse(line);
    } catch {
      continue;
    }

    if (message.id === 1) {
      send({ jsonrpc: "2.0", method: "notifications/initialized", params: {} });
      send({
        jsonrpc: "2.0",
        id: 2,
        method: "tools/call",
        params: { name: toolName, arguments: toolArgs },
      });
    } else if (message.id === 2) {
      finished = true;
      handleResult(message.result)
        .then(() => child.kill())
        .catch((error) => {
          console.error(error.message);
          child.kill();
          process.exitCode = 1;
        });
    }
  }
});

child.stderr.on("data", (data) => {
  process.stderr.write(data);
});

child.on("exit", () => {
  if (!finished && process.exitCode == null) {
    console.error(`Windows-MCP exited before ${toolName} completed.`);
    process.exitCode = 1;
  }
});

send({
  jsonrpc: "2.0",
  id: 1,
  method: "initialize",
  params: {
    protocolVersion: "2025-06-18",
    capabilities: {},
    clientInfo: { name: "agent-town-desktop-ui-test", version: "0.1.0" },
  },
});

setTimeout(() => {
  if (!finished) {
    console.error(`Timed out waiting for Windows-MCP ${toolName}.`);
    child.kill();
    process.exit(1);
  }
}, Number.parseInt(process.env.WINDOWS_MCP_CALL_TIMEOUT_MS ?? "90000", 10));
