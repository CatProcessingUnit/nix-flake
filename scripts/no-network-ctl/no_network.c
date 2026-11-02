// todo:
// cleanup code

#include <iso646.h>
#include <json-c/json_types.h>
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

json_object* get_nft_rules_by_comment(char* comment) {
	if (nft_run_cmd_from_buffer(json_ctx, "list table inet filter") != 0) {
		puts("list table failed");
		exit(1);
	};
	const char* nft_output_buffer = nft_ctx_get_output_buffer(json_ctx);
	if (nft_output_buffer == NULL) {
		puts("nft_ctx_get_output_buffer() failed");
		exit(1);
	}

	json_object* json_output = json_tokener_parse(nft_output_buffer);
	
	if (json_output == NULL) {
		printf("failed to parse buffer\n %s", nft_output_buffer);
		exit(1);
	}
	json_object* json_array = json_object_object_get(json_output, "nftables");
	if (json_array == NULL && !json_object_is_type(json_output, json_type_array)) {
		puts("buffer returned wrong result");
		exit(1);
	};
	puts("A1");
	int n = json_object_array_length(json_array);
	json_object* result = json_object_new_array();
	if (result == NULL) {
		puts("failed to create new json object");
		exit(1);
	}
	int result_size = 0;
	puts("A2");
	for (int i = 0; i < n; i++) {
		puts("AAA123123");
		json_object* entry = json_object_array_get_idx(json_array, i);
		puts("A3");
		if (entry == NULL) {
			puts("failed to get entry");
			exit(1);
		};
		json_object* rule = json_object_object_get(entry, "rule");
		puts("A4");
		if (rule != NULL) {
			json_object* rule_comment = json_object_object_get(rule, "comment");
			puts("A5");
			printf("rule_comment is not null: %d\n", rule_comment != NULL);
			printf("rule_comment value: %s\n", json_object_get_string(rule_comment));
			printf("comment value: %s\n", comment);
			printf("rule_comment equals comment: %d\n", json_object_get_string(rule_comment) == comment);
			// use strcmp
			// because these are pointers!
			if (rule_comment != NULL && strcmp(json_object_get_string(rule_comment), comment) == 0) {
				puts("A6");
				result_size += 1;
				json_object_array_insert_idx(result, result_size - 1, rule);
				puts("A7");
			};
		}
	};
	
	free(json_output);
	nft_ctx_unbuffer_output(json_ctx);
	
	printf("rules are null: %d\n", result == NULL);

	return result;
}

void delete_rule(int handle) {
	printf("deleting handle %d\n", handle);
	char* cmd = NULL;
	asprintf(&cmd, "delete rule inet filter output handle %d", handle);
	nft_run_cmd_from_buffer(empty_ctx, cmd);
	free(cmd);
}

const char* get_rule_slice(json_object* nft_rule) {
	json_object* expr = json_object_object_get(nft_rule, "expr");
	if (expr != NULL && json_object_is_type(expr, json_type_array)) {
		json_object* expr_data = NULL;
		for (int x = 0; true; x++) {
			expr_data = json_object_array_get_idx(expr, x);
			if (expr_data == NULL) {
				break;
			};
			json_object* match;
			json_object* left;
			json_object* socket;
			json_object* right;
			json_object* key;
			// check if its cgroupsv2
			if (
				json_object_object_get_ex(expr_data, "match", &match) &&
				json_object_object_get_ex(match, "right", &right) &&
				json_object_object_get_ex(match, "left", &left) &&
				json_object_object_get_ex(left, "socket", &socket) &&
				json_object_object_get_ex(socket, "key", &key) &&

				json_object_is_type(key, json_type_string) &&
				json_object_is_type(right, json_type_string) &&

				strcmp(json_object_get_string(key), "cgroupsv2")) 
			{
				puts("slice ok");
				return json_object_get_string(right);
			}
		}
	}
	return NULL;	
}

// iterate through rules matching get_slice_comment()
// and delete rules not matching get_slice_path()
// because nft rules using cgroups break, when the cgroup stops existing
// (value turns to some weird numbers)
void delete_invalid_rules(json_object* rules) {	
	if (rules != NULL) {
		json_object* entry = NULL;
		
		for (int i = 0; true; i++) {
			entry = json_object_array_get_idx(rules, i);
			if (entry == NULL) {
				break;
			};
			const char* comment = json_object_get_string(json_object_object_get(entry, "comment"));
			char* target_comment = get_slice_comment();
			if (strcmp(comment, target_comment) == 0) {
				int handle = json_object_get_int(json_object_object_get(entry, "handle"));
				printf("rule with handle %d is created by this user\n", handle);
				const char* slice = NULL;
				json_object* expr = json_object_object_get(entry, "expr");
				slice = get_rule_slice(entry);
				char* target_slice = get_slice_path();
				printf("target_slice: %s\n slice: %s\n", target_slice, slice);
				if (slice != NULL && strcmp(slice, target_slice) != 0 && handle != 0) {
					delete_rule(handle);
				}
				free(target_slice);
			}
			free(target_comment);
		}	
	}
};

bool check(json_object* current_rules) {
	json_object* entry = NULL;
	for (int i = 0; true; i++) {
		entry = json_object_array_get_idx(current_rules, i);
		if (entry == NULL) {
			break;
		};
		const char* comment = json_object_get_string(json_object_object_get(entry, "comment"));
		char* target_comment = get_slice_comment();
		puts("d1");
		if (strcmp(comment, target_comment) == 0) {
			puts("d2");
			const char* slice = get_rule_slice(entry);
			char* target_slice = get_slice_path();
			if (slice != NULL && strcmp(slice, target_slice) == 0) {
				free(target_slice);
				return true;
			}
			free(target_slice);
		}
		free(target_comment);
	}
	return false;
}

void stop() {
	not_implemented();
}

void start() {
	json_object* current_rules = get_nft_rules_by_comment(get_slice_comment());
	delete_invalid_rules(current_rules);
	char* rule = NULL;
	char* path = get_slice_path();
	char* comment = get_slice_comment();
	bool already_started = check(current_rules);
	if (!already_started) {
		// spawn a keeper process for the slice, if one doesn't already exist
		// because rules can only be added for existing slices
		system("systemctl list-unit-files --user \"no-network-keeper.service\" > /dev/null || systemd-run --user --slice=app-nonetwork.slice --unit \"no-network-keeper\" sleep infinity > /dev/null");
		asprintf(&rule, "add rule inet filter output socket cgroupv2 level 5 \"%s\" oifname != \"lo\" drop comment \"%s\"", path, comment);
		nft_run_cmd_from_buffer(empty_ctx, rule);
		puts("asdasdasdasd");
	} else {
		puts("already running");
	}
	free(rule);
	free(comment);
	free(path);
}

int main(int argc, char** argv) {
	if (getuid() == 0) {
		puts("this program doesn't work when running as root");
		return 1;
	}
	// nftables ctx setup
	json_ctx = nft_ctx_new(NFT_CTX_DEFAULT);
	if (json_ctx == NULL) {
		puts("nft_ctx_new() fail");
		return 1;
	};
	nft_ctx_output_set_flags(json_ctx, NFT_CTX_OUTPUT_JSON | NFT_CTX_OUTPUT_HANDLE);
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
