preinstall-ts-parsers:
	nvim --headless -u tests/init.lua -c "TSUpdate | qa"

test-utils:
		nvim --headless -u tests/init.lua -c "PlenaryBustedDirectory tests/utils/${LP} { minimal_init = 'tests/init.lua' }"

test-node-processors:
	nvim --headless -u tests/init.lua -c "PlenaryBustedDirectory tests/node-processors/${LP} { minimal_init = 'tests/init.lua' }"

test:
	make test-node-processors
