# bun-test-containers-race-condition
A self contained example that can easily reporduce the error seen in Bun when using test containers

This project is completely self contained, just checkout and open a terminal and run 

```
./run
```

Or if you want the full logs run

```
DEBUG=testcontainers* ./run
```

Example output

```
$ ./run
mise all tools are installed
bun install v1.2.8 (adab0f64)

Checked 160 installs across 156 packages (no changes) [4.00ms]
Ensure no Ryuk containers are running, so it fails to start
bun test v1.2.8 (adab0f64)

postgres.test.ts:
Running with RYUK_CONTAINER_IMAGE=testcontainers/ryuk:0.11.0
error: Test "Test will fail if ryuk is not started and then starts too quickly" timed out after 15000ms
✗ Reaper test > Test will fail if ryuk is not started and then starts too quickly [15000.57ms]

 0 pass
 1 fail
Ran 1 tests across 1 files. [15.23s]
If we run a second time, it will work as ryuk is already running
CONTAINER ID   IMAGE                        COMMAND       CREATED          STATUS          PORTS                                         NAMES
46f5a86a1c9c   testcontainers/ryuk:0.11.0   "/bin/ryuk"   15 seconds ago   Up 14 seconds   0.0.0.0:32828->8080/tcp, :::32828->8080/tcp   testcontainers-ryuk-ccc9b42e1a50
bun test v1.2.8 (adab0f64)

postgres.test.ts:
Running with RYUK_CONTAINER_IMAGE=testcontainers/ryuk:0.11.0
IT STARTED
✓ Reaper test > Test will fail if ryuk is not started and then starts too quickly [6909.26ms]

 1 pass
 0 fail
Ran 1 tests across 1 files. [7.16s]
Or is we use a custom image that sleeps for 5 seconds before it starts
46f5a86a1c9c
Untagged: slow-ryuk:latest
Deleted: sha256:2d43938ea430eec372f5c5bfc95cd2ecd06ccc3f7b31f2b6d6ef274378ac3696
[+] Building 0.0s (5/5) FINISHED                                                                                                                                                                                                                                                                                                                                         docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                                                                                                                                               0.0s
 => => transferring dockerfile: 126B                                                                                                                                                                                                                                                                                                                                               0.0s
 => [internal] load metadata for docker.io/testcontainers/ryuk:0.11.0                                                                                                                                                                                                                                                                                                              0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                                                                                                                                                                  0.0s
 => => transferring context: 2B                                                                                                                                                                                                                                                                                                                                                    0.0s
 => CACHED [1/1] FROM docker.io/testcontainers/ryuk:0.11.0                                                                                                                                                                                                                                                                                                                         0.0s
 => exporting to image                                                                                                                                                                                                                                                                                                                                                             0.0s
 => => exporting layers                                                                                                                                                                                                                                                                                                                                                            0.0s
 => => writing image sha256:2d43938ea430eec372f5c5bfc95cd2ecd06ccc3f7b31f2b6d6ef274378ac3696                                                                                                                                                                                                                                                                                       0.0s
 => => naming to docker.io/library/slow-ryuk                                                                                                                                                                                                                                                                                                                                       0.0s
bun test v1.2.8 (adab0f64)

postgres.test.ts:
Running with RYUK_CONTAINER_IMAGE=slow-ryuk
IT STARTED
✓ Reaper test > Test will fail if ryuk is not started and then starts too quickly [6891.26ms]

 1 pass
 0 fail
Ran 1 tests across 1 files. [7.14s]
```

Basically if the image that reaper runs (testcontains/ryuk) finishes very quickly the first time it run test containers will miss the output. However if the container is still up from a previous run then it will pass or if the image is modified to sleep first then it will correctly detect the "Started" string in the logs.


