FROM testcontainers/ryuk:0.11.0
ENTRYPOINT ["/bin/sh", "-c", "sleep 5 && exec /bin/ryuk"]