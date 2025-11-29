"""
WebSocket Routes

WebSocket endpoint for receiving real-time NFL data updates.
Clients can subscribe to league or player-specific updates.
"""
import logging

from fastapi import APIRouter, WebSocket, WebSocketDisconnect

from src.infrastructure.adapters.websocket_service import ws_manager

logger = logging.getLogger(__name__)

router = APIRouter(tags=["websocket"])


@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    """
    Main WebSocket endpoint for receiving NFL data updates.

    Protocol:
    1. Connect to ws://host:port/ws
    2. Send subscription messages:
       - {"action": "subscribe_league", "league_id": "xxx"}
       - {"action": "subscribe_player", "player_id": "xxx"}
    3. Receive update messages:
       - {"type": "PLAYER_STATS", "deltas": [...]}
       - {"type": "GAME_SCORES", "deltas": [...]}
       - {"type": "LEADERBOARD_UPDATE", "league_id": "xxx", "leaderboard": [...]}
       - {"type": "SYNC_STATUS", "status": {...}}
    """
    await ws_manager.connect(websocket)
    try:
        while True:
            # Receive subscription requests from client
            data = await websocket.receive_json()

            action = data.get("action")
            if action == "subscribe_league":
                league_id = data.get("league_id")
                if league_id:
                    ws_manager.subscribe_to_league(websocket, league_id)
                    await websocket.send_json({
                        "type": "SUBSCRIPTION_CONFIRMED",
                        "subscription_type": "league",
                        "id": league_id,
                    })
                    logger.info(f"Client subscribed to league {league_id}")

            elif action == "subscribe_player":
                player_id = data.get("player_id")
                if player_id:
                    ws_manager.subscribe_to_player(websocket, player_id)
                    await websocket.send_json({
                        "type": "SUBSCRIPTION_CONFIRMED",
                        "subscription_type": "player",
                        "id": player_id,
                    })
                    logger.info(f"Client subscribed to player {player_id}")

            elif action == "ping":
                await websocket.send_json({"type": "pong"})

            else:
                await websocket.send_json({
                    "type": "ERROR",
                    "message": f"Unknown action: {action}",
                })

    except WebSocketDisconnect:
        ws_manager.disconnect(websocket)
        logger.info("WebSocket client disconnected")
    except Exception as e:
        logger.error(f"WebSocket error: {e}")
        ws_manager.disconnect(websocket)


@router.get("/ws/stats")
async def get_websocket_stats():
    """
    Get WebSocket connection statistics.

    Returns connection counts and subscription info.
    """
    return ws_manager.get_stats()
