# TODO: R-rebranding Project

## Current Status: ✅ Base Rebranding Complete
- Code-level rebranding (version, banner, copyright, package name)
- Patch workflow: `make patch && make build`
- Install location: `/local/Appz/R-${VERSION}-b2b`
- Verified working: R 4.2.1 with B2B-Enhanced branding

---

## Next Phase: Parallel BLAS/LAPACK (MRO-style)

### High Priority
- [ ] **1. Update build.sh with OpenBLAS flags**
    - Add `--with-blas/--with-lapack=openblas`
    - pkg-config detection for OpenBLAS
    - CFLAGS/FFLAGS/CXXFLAGS with OpenBLAS include path
    - Priority: High

- [ ] **2. Add OpenBLAS build dependencies**
    - Document `libopenblas-dev` installation in README/build docs
    - Priority: High

- [ ] **3. Update Rprofile.site with parallel defaults**
    - Auto-detect cores (`parallel::detectCores`)
    - Set `OPENBLAS_NUM_THREADS`, `OMP_NUM_THREADS`, `MKL_NUM_THREADS`
    - Default to physical cores / 2, max 8
    - Show message at startup
    - Priority: High

- [ ] **7. Test BLAS linkage and threading**
    - Verify `sessionInfo()` shows OpenBLAS
    - Test thread control via env vars (`OPENBLAS_NUM_THREADS`, `OMP_NUM_THREADS`)
    - Priority: High

### Medium Priority
- [ ] **4. Update version.c PrintGreeting**
    - Print BLAS backend and thread count in startup banner
    - Priority: Medium

- [ ] **5. Add etc/Makevars.site for packages**
    - Ensure packages compile with same BLAS/LAPACK
    - `BLAS_LIBS = $(OPENBLAS_LIB)`
    - `LAPACK_LIBS = $(OPENBLAS_LIB)`
    - Priority: Medium

- [ ] **6. Update etc/Makefile.in to install Makevars.site**
    - Install Makevars.site to `$R_HOME/etc/`
    - Priority: Medium

- [ ] **8. Benchmark matrix operations**
    - Compare performance vs reference BLAS
    - Verify thread scaling (1, 2, 4, 8 threads)
    - Priority: Medium

### Low Priority
- [ ] **9. Optional: FlexiBLAS integration**
    - Add flexiblas support for runtime backend switching
    - `flexiblas_load_backend("OPENBLAS")`
    - Priority: Low

---

## Build Script Changes (build.sh)
```bash
OPENBLAS_LIB=$(pkg-config --libs openblas 2>/dev/null || echo "-lopenblas")
OPENBLAS_CFLAGS=$(pkg-config --cflags openblas 2>/dev/null)

./configure \
  --with-blas="$OPENBLAS_LIB" \
  --with-lapack="$OPENBLAS_LIB" \
  --with-R-shlib \
  --prefix=/local/Appz/R-${VERSION}-b2b \
  CFLAGS="-std=c17 -D_POSIX_C_SOURCE=200809L -D_GNU_SOURCE $OPENBLAS_CFLAGS" \
  FFLAGS="$OPENBLAS_CFLAGS" \
  CXXFLAGS="$OPENBLAS_CFLAGS"
```

## Dependencies
```bash
sudo apt-get install -y libopenblas-dev
```

## Rprofile.site Addition
```r
local({
  ncpu <- parallel::detectCores(logical = TRUE)
  nthreads <- min(max(ncpu %/% 2, 1), 8)
  Sys.setenv(
    OPENBLAS_NUM_THREADS = nthreads,
    OMP_NUM_THREADS = nthreads,
    MKL_NUM_THREADS = nthreads
  )
  message(sprintf("R-B2B: BLAS threads set to %d", nthreads))
})
```

## Testing Checklist
```bash
# Verify BLAS
R -e 'sessionInfo()'

# Test thread control
OPENBLAS_NUM_THREADS=4 R -e 'library(RhpcBLASctl); blas_get_num_procs()'

# Benchmark
R -e 'm <- matrix(rnorm(1e6), 1000); system.time(m %*% m)'
```

---

## Completed (Base Rebranding)
- [x] VERSION-NICK → `B2B-Enhanced`
- [x] configure.ac → `AC_INIT([R-B2B], ...)` + custom URLs
- [x] m4/R.m4 → libcurl 8.x version check fix
- [x] src/main/version.c → startup banner + copyright rebrand
- [x] Rprofile.site → CRAN mirror + startup branding
- [x] build.sh → CFLAGS + prefix `/local/Appz/R-${VERSION}-b2b`
- [x] patch.sh → copies Rprofile.site + applies rebrand-code.patch
- [x] rebrand-code.patch → source-level changes
- [x] Makefile → init/update/deps/patch/build targets
- [x] Verified build at `/local/Appz/R-4.2.1-b2b`
- [x] Parent repo pushed to GitHub