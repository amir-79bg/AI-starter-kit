import type { NextConfig } from "next";
import { networkInterfaces } from "node:os";

const nextConfig: NextConfig = {
  outputFileTracingRoot: process.cwd(),
  allowedDevOrigins: Object.values(networkInterfaces()).flat()
    .filter((address) => address && !address.internal && address.family === "IPv4")
    .map((address) => address!.address),
};

export default nextConfig;
