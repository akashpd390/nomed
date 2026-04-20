import { Router } from "express";
import { login, register, verify } from "../controller/auth.controller";
import authMiddleware from "../middleware/auth.middleware";

const authRouter = Router();

authRouter.post("/register", register);
authRouter.post("/login", login);
authRouter.get("/verify", authMiddleware, verify);

export default authRouter;
