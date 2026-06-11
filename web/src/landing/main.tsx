import { createRoot } from "react-dom/client";
import "@/ui/pixel.css";

function Landing() {
  return (
    <div
      className="pixel-font"
      style={{ minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center", background: "#15101e" }}
    >
      <div className="wood-panel" style={{ padding: 28, textAlign: "center", maxWidth: 520 }}>
        <h1 style={{ margin: "0 0 8px", color: "var(--wood-dark)" }}>新路谷物语 · Xinlu Valley</h1>
        <p style={{ margin: "0 0 18px" }}>一座长在真实工作系统上的像素小镇。完整首页建设中——小镇已经开门。</p>
        <a className="wood-btn" style={{ textDecoration: "none", fontSize: 18, padding: "10px 26px" }} href="/play.html">
          ▶ 进入小镇
        </a>
      </div>
    </div>
  );
}

createRoot(document.getElementById("root")!).render(<Landing />);
