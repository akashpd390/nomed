import { Router } from "express";
import authMiddleware from "../middleware/auth.middleware";
import { createRoom, fetchAllRoom, fetchById, fetchNearBy, fetchRoomThatUserJoins, joinRoom, leaveRoom } from "../controller/room.controller";


const roomRouter = Router();


roomRouter.get("/", fetchAllRoom);
roomRouter.get("/near", fetchNearBy);
roomRouter.get("/joined", authMiddleware,  fetchRoomThatUserJoins);
roomRouter.get("/:roomId", fetchById);
roomRouter.post("/create", authMiddleware, createRoom);
roomRouter.post("/join", authMiddleware, joinRoom);
roomRouter.delete("/:roomId/leave", authMiddleware, leaveRoom);


export default roomRouter;