#include <iso646.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/capability.h>
#include <nftables/libnftables.h>
#include <json-c/json.h>
#include <json-c/json_object.h>

struct nft_ctx* json_ctx;
struct nft_ctx* empty_ctx;

char* get_slice_comment() {
	char* str = NULL;
	asprintf(&str, "no-network-%d", getuid());
	return str;
};

char* get_slice_path() {
	char* str = NULL;
	asprintf(&str, "user.slice/user-%d.slice/user@%d.service/app.slice/app-nonetwork.slice", getuid(), getuid());
	return str;
}

void not_implemented() {
	puts("function is not implemented");
	exit(1);
};

void usage() {
	puts(
		"start - Enable the slice\n"
		"stop - Disable the slice and restore network for all programs inside\n"
		"check - Check if the slice if enabled"
	);
};

json_object** get_nft_rules_by_comment(char* comment) {
	not_implemented();
}

bool check() {
	not_implemented();	
}

void delete_rule(int handle) {
	not_implemented();
}

void stop() {
	not_implemented();
}

// todo:
// check if a rule already exists
// because it keeps creating new rules every launch!
void start() {
	char* rule = NULL;
	char* path = get_slice_path();
	char* comment = get_slice_comment();
	// spawn a keeper process for the slice, if one doesn't already exist
	// because rules can only be added for existing slices
	system("systemctl list-unit-files --user \"no-network-keeper.service\" > /dev/null || systemd-run --user --slice=app-nonetwork.slice --unit \"no-network-keeper\" sleep infinity > /dev/null");
	asprintf(&rule, "add rule inet filter output socket cgroupv2 level 5 \"%s\" oifname != \"lo\" drop comment \"%s\"", path, comment);
	nft_run_cmd_from_buffer(empty_ctx, rule);
	free(rule);
	free(path);
	free(comment);
}

int main(int argc, char** argv) {
	// nftables ctx setup
	json_ctx = nft_ctx_new(NFT_CTX_DEFAULT);
	if (json_ctx == NULL) {
		puts("nft_ctx_new() fail");
		return 1;
	};
	nft_ctx_output_set_flags(json_ctx, NFT_CTX_OUTPUT_JSON);
	nft_ctx_output_set_flags(json_ctx, NFT_CTX_OUTPUT_HANDLE);
	nft_ctx_buffer_output(json_ctx);

	empty_ctx = nft_ctx_new(NFT_CTX_DEFAULT);
	if (empty_ctx == NULL) {
		puts("nft_new_ctx() failed");
		return 1;
	};

	// check capabilities
	cap_t caps = cap_get_proc();
	cap_flag_value_t proc_has_cap_net_admin;
	if (caps == NULL) {
		puts("cap_get_proc() fail");
		return 1;
	};
	if (cap_get_flag(caps, CAP_NET_ADMIN, CAP_PERMITTED, &proc_has_cap_net_admin) == -1) {
		puts("cap_get_flag() failed");
		return 1;
	};

	if (proc_has_cap_net_admin == CAP_CLEAR) {
		puts(
			"Operation not permitted\n"
			"CAP_NET_ADMIN is required"
		);
		return 1;
	}

	// enable/disable
	if (argv[1] == NULL) {
		usage();
		return 0;
	} else if (strcmp("start", argv[1]) == 0) {
		start();	
	} else if (strcmp("stop", argv[1]) == 0) {
		stop();
	} else {
		printf("unknown option %s", argv[1]);
		return 1;
	};

	return 0;
}
