import asyncio
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from models import ActivityState
from town_engine import TownEngine


class TownEngineTest(unittest.TestCase):
    def test_simple_path_reaches_exact_target(self):
        engine = TownEngine()

        path = engine._simple_path((0, 0), (39, 29))

        self.assertTrue(path)
        self.assertEqual(path[-1], (39, 29))
        self.assertGreater(len(path), 11)

    def test_player_move_advances_on_tick_until_arrival(self):
        engine = TownEngine()
        player = engine.agents["player"]

        engine.move_player(25, 20)
        self.assertEqual(player.target_position, (25, 20))
        self.assertEqual(player.current_activity, ActivityState.WALKING)

        for _ in range(20):
            asyncio.run(engine.tick())
            if player.position == (25, 20):
                break

        self.assertEqual(player.position, (25, 20))
        self.assertEqual(player.path, [])
        self.assertIsNone(player.target_position)
        self.assertEqual(player.current_activity, ActivityState.IDLE)

    def test_player_move_to_current_position_does_not_leave_stale_target(self):
        engine = TownEngine()
        player = engine.agents["player"]

        engine.move_player(*player.position)

        self.assertEqual(player.path, [])
        self.assertIsNone(player.target_position)
        self.assertEqual(player.current_activity, ActivityState.IDLE)


if __name__ == "__main__":
    unittest.main()
