import { Router } from "express";
import authMiddleware from "../middleware/auth.middleware";
import { fetchMessage, sendMessage } from "../controller/messages.controller";

const messageRouter = Router();


messageRouter.get("/:roomId", authMiddleware, fetchMessage);
messageRouter.post("/", authMiddleware, sendMessage);

export default messageRouter;