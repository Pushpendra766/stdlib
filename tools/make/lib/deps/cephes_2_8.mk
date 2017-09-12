
# VARIABLES #

# Define the download URL:
DEPS_CEPHES_URL ?= http://www.moshier.net/cephes-math-28.tar.gz

# Determine the basename for the download:
deps_cephes_basename := $(notdir $(DEPS_CEPHES_URL))

# Define the path to the file containing a checksum verify a download:
DEPS_CEPHES_CHECKSUM ?= $(shell cat $(DEPS_CHECKSUMS_DIR)/$(subst -,_,$(subst .,_,$(deps_cephes_basename)))/sha256)

# Define the output path when downloading:
DEPS_CEPHES_DOWNLOAD_OUT ?= $(DEPS_TMP_DIR)/$(deps_cephes_basename)

# Define the output path when building:
deps_cephes_build_out := $(DEPS_CEPHES_BUILD_OUT)/cephes

# Define the path to the directory containing tests:
DEPS_CEPHES_TEST_DIR ?= $(DEPS_DIR)/test/cephes

# Define the output directory path for compiled tests:
DEPS_CEPHES_TEST_OUT ?= $(DEPS_CEPHES_TEST_DIR)/build

# Define the path to a test file for checking an installation:
DEPS_CEPHES_TEST_INSTALL ?= $(DEPS_CEPHES_TEST_DIR)/test_install.c

# Define the output path for a test file:
DEPS_CEPHES_TEST_INSTALL_OUT ?= $(DEPS_CEPHES_TEST_OUT)/test_install

# Define a list of source files:
deps_cephes_src := double/acosh.c double/airy.c double/asin.c double/asinh.c double/atan.c double/atanh.c double/bdtr.c double/beta.c double/btdtr.c double/cbrt.c double/chbevl.c double/chdtr.c double/const.c double/cosh.c double/dawsn.c double/drand.c double/ei.c double/ellie.c double/ellik.c double/ellpe.c double/ellpj.c double/ellpk.c double/exp.c double/exp10.c double/exp2.c double/expn.c double/fabs.c double/fac.c double/fdtr.c double/fresnl.c double/gamma.c double/gdtr.c double/hyp2f1.c double/hyperg.c double/i0.c double/i1.c double/igami.c double/incbet.c double/incbi.c double/igam.c double/isnan.c double/iv.c double/j0.c double/j1.c double/jn.c double/jv.c double/k0.c double/k1.c double/kn.c double/kolmogorov.c double/log.c double/log2.c double/log10.c double/lrand.c double/nbdtr.c double/ndtr.c double/ndtri.c double/pdtr.c double/polevl.c double/polylog.c double/pow.c double/powi.c double/psi.c double/rgamma.c double/round.c double/shichi.c double/sici.c double/sin.c double/sindg.c double/sinh.c double/spence.c double/stdtr.c double/struve.c double/tan.c double/tandg.c double/tanh.c double/unity.c double/yn.c double/zeta.c double/zetac.c double/sqrt.c double/floor.c double/setprec.c double/mtherr.c

# Resolve a list of source files to absolute filepaths:
DEPS_CEPHES_SRC ?= $(addprefix $(deps_cephes_build_out)/,$(deps_cephes_src))


# TARGETS #

# Download.
#
# This target downloads a Cephes distribution.

$(DEPS_CEPHES_DOWNLOAD_OUT): | $(DEPS_TMP_DIR)
	$(QUIET) echo 'Downloading Cephes...' >&2
	$(QUIET) $(DEPS_DOWNLOAD_BIN) $(DEPS_CEPHES_URL) $(DEPS_CEPHES_DOWNLOAD_OUT)


# Extract.
#
# This target extracts a gzipped tar archive.

$(deps_cephes_build_out): $(DEPS_CEPHES_DOWNLOAD_OUT)
	$(QUIET) echo 'Extracting Cephes...' >&2
	$(QUIET) $(MKDIR_RECURSIVE) $@
	$(QUIET) $(TAR) -zxf $(DEPS_CEPHES_DOWNLOAD_OUT) -C $(DEPS_CEPHES_BUILD_OUT)


# Create directory for tests.
#
# This target creates a directory for storing compiled tests.

$(DEPS_CEPHES_TEST_OUT):
	$(QUIET) $(MKDIR_RECURSIVE) $(DEPS_CEPHES_TEST_OUT)


# Compile install test.
#
# This target compiles a test file for testing an installation.

$(DEPS_CEPHES_TEST_INSTALL_OUT): $(deps_cephes_build_out) $(DEPS_CEPHES_TEST_OUT)
	$(QUIET) $(CC) -I $(DEPS_CEPHES_BUILD_OUT) \
		$(DEPS_CEPHES_TEST_INSTALL) \
		$(DEPS_CEPHES_SRC) \
		-o $(DEPS_CEPHES_TEST_INSTALL_OUT)


# Download Cephes.
#
# This target downloads a Cephes distribution.

deps-download-cephes: $(DEPS_CEPHES_DOWNLOAD_OUT)

.PHONY: deps-download-cephes


# Verify download.
#
# This targets verifies a download.

deps-verify-cephes: deps-download-cephes
	$(QUIET) echo 'Verifying download...' >&2
	$(QUIET) $(DEPS_CHECKSUM_BIN) $(DEPS_CEPHES_DOWNLOAD_OUT) $(DEPS_CEPHES_CHECKSUM) >&2

.PHONY: deps-verify-cephes


# Extract Cephes.
#
# This target extracts a Cephes download.

deps-extract-cephes: $(deps_cephes_build_out)

.PHONY: deps-extract-cephes


# Test install.
#
# This target tests an installation.

deps-test-cephes: $(DEPS_CEPHES_TEST_INSTALL_OUT)
	$(QUIET) echo 'Running tests...' >&2
	$(QUIET) $(DEPS_CEPHES_TEST_INSTALL_OUT)
	$(QUIET) echo '' >&2
	$(QUIET) echo 'Success.' >&2

.PHONY: deps-test-cephes
