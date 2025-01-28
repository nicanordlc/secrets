# vim: ts=8:sw=8

ENCRYPTED_PATH	:= $(shell cat ENV_ENCRYPTED_PATH)
DECRYPTED_PATH	:= $(shell cat ENV_DECRYPTED_PATH)

FILES		:= ""
IGNORE		:= ! -name ".git" ! -name "Session.vim"
GPG_FILES_SRC	:= $(shell find $(ENCRYPTED_PATH) -type f -name "*.gpg" $(IGNORE))
GPG_FILES_OUT	:= $(patsubst $(ENCRYPTED_PATH)/%.gpg,$(DECRYPTED_PATH)/%,$(GPG_FILES_SRC))

.PHONY: help
help:
	@echo "Commands:"
	@cat ./Makefile | grep '.PHONY:[[:space:]]' | sed 's;^.*[[:space:]];- ;'

#########
#       #
# RuleZ #
#       #
#########

.PHONY: init
init: create-dots bootstrap-key decrypt

# Crypto
########

.PHONY: add
add:
	@./src/bin/encrypt.sh

.PHONY: decrypt
decrypt: $(GPG_FILES_OUT) post-decrypt
$(DECRYPTED_PATH)/%: $(ENCRYPTED_PATH)/%.gpg
	@mkdir -p $(dir $@)
	@echo "[Decrypting] $<"
	@./src/bin/decrypt.sh $< > $@

# Git management
################

.PHONY: show
show:
	@./src/bin/show.sh $(FILES)

.PHONY: diff
diff:
	@./src/bin/diff.sh

.PHONY: status
status:
	@echo $(DECRYPTED_PATH)
	@echo $(DECRYPTED_PATH) | sed 's;.;=;g'
	@echo
	@cd dots && git status

.PHONY: checkout
checkout:
	@echo "dots"
	@echo "===="
	@echo
	@cd dots && git checkout .

################
#              #
# Helper Rules #
#              #
################

.PHONY: post-decrypt
post-decrypt:
	@./src/bin/git-init.sh

.PHONY: bootstrap-key
bootstrap-key:
	@./src/bin/bootstrap-key.sh

.PHONY: create-dots
create-dots:
	@mkdir -p $(DECRYPTED_PATH)

