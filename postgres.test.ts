import {describe, it} from "bun:test";
import {PostgreSqlContainer} from "@testcontainers/postgresql";

describe("Reaper test", () => {
    it("Test will fail if ryuk is not started and then starts too quickly", async () => {
        console.log(`Running with RYUK_CONTAINER_IMAGE=${process.env.RYUK_CONTAINER_IMAGE}`);
        try {
            const container = await new PostgreSqlContainer().start();
            console.log("IT STARTED");
            await container.stop();
        } catch (e) {
            console.error("Failed to start container", e.message);
        }
    });
})
