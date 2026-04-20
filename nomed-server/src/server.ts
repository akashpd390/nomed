
import http from "http";
import app from "./app";
import { connectDB } from "./config/db";
import { env } from "./config/env";
import { initSocket } from "./socket/socket";


const server = http.createServer(app);

connectDB();
initSocket(server);

server.listen(env.PORT, () => {
    console.log(`🚀 Server running on port ${env.PORT}`);
});
