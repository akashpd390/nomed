
import express, { Response, Request } from "express";

import cors from 'cors';
import authRouter from "./router/auth.route";
import roomRouter from "./router/room.route";
import messageRouter from "./router/message.route";

const app = express();

app.use(express.json());


// Cors
app.use(cors({
    origin: "0.0.0.0",
    credentials: true
}));

app.use("/api/room", roomRouter);

app.use("/api/message", messageRouter);

app.use("/api/auth", authRouter);

app.get("/checkHealth", (req: Request, res: Response) => {


    res.status(200).json({ mess: "everything is fne " });


})

export default app;
