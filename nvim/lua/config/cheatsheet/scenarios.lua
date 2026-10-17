-- Step-by-step recipes for real tasks (cheatsheet tab 2).
-- { title, icon, goal, steps = { { keys, what happens } }, tip? }
return {
	{ "Open a project and get your bearings", "tree",
		"You just cloned a repo and want to look around.",
		{
			{ "nvim .", "opens nvim with the file tree on the left" },
			{ "Space f", "type part of a filename, Enter to open it" },
			{ "Space Fs", "list the functions in this file, jump to one" },
			{ "Space g", "search for a word you saw in the README" },
			{ "Space o", "later: reopen the files you had here" },
		},
		"Next day, Space Ss restores every window and buffer from this session." },

	{ "Find where a function is used", "search",
		"You want every caller of a function before changing it.",
		{
			{ "gd", "on a call: jump to the definition" },
			{ "gr", "on the name: list every reference" },
			{ "Ctrl-n / Enter", "walk the list, open one" },
			{ "Ctrl-o", "jump back to where you were" },
			{ "Space G", "no language server? grep the word instead" },
		} },

	{ "Rename something everywhere", "fix",
		"A function, variable or type has a bad name.",
		{
			{ "cursor on the name", "anywhere in the word" },
			{ "Space rn", "type the new name, Enter" },
			{ ":wa", "save every changed file" },
		},
		"Renaming a file instead? Space cR, and imports are updated." },

	{ "Replace text in the whole project", "grep",
		"Change a string in many files, e.g. an old URL.",
		{
			{ "Space g", "grep the old text" },
			{ "Alt-a then Enter", "select all results, send them to quickfix" },
			{ ":cdo s/old/new/g", "run the replace on every quickfix line" },
			{ ":wa", "save all files" },
		},
		"Add c at the end (s/old/new/gc) to confirm each one." },

	{ "Fix the errors in a file", "lsp",
		"Red underlines after a change.",
		{
			{ "]d", "jump to the next error, message shows" },
			{ "Space ca", "pick a quick fix (missing import, typo, ...)" },
			{ "Space e", "read the full message if it is cut off" },
			{ "Space T", "see every error in the project as a list" },
			{ "Space cf", "format the file when done" },
		} },

	{ "Change the same thing on many lines", "cursor",
		"Rename a word in 6 places in one function, or edit a column.",
		{
			{ "cursor on the word", "the word you want to change" },
			{ "Space mn", "repeat: adds a cursor at each next match" },
			{ "Space ms", "skip a match you do not want" },
			{ "ciw + new text", "type once, every cursor changes" },
			{ "Esc", "back to one cursor" },
		},
		"Simple alternative: * to search the word, cgn to change it, then . to repeat on the next one." },

	{ "Move a block of code", "bolt",
		"A function is in the wrong place.",
		{
			{ "daf", "cut the whole function" },
			{ "s + 2 letters", "jump to where it should go" },
			{ "p", "paste it below" },
		},
		"For a few lines: select with V and press Alt-j / Alt-k." },

	{ "Wrap or unwrap code", "code",
		"Add quotes, brackets or a tag around something.",
		{
			{ "ysiw\"", "put quotes around a word" },
			{ "V then S)", "put parens around the selected lines" },
			{ "cs\"'", "turn \"x\" into 'x'" },
			{ "ds(", "remove the parens around the cursor" },
		} },

	{ "Extract a function", "fix",
		"A long function needs a helper.",
		{
			{ "V + j/k", "select the lines to move out" },
			{ "Space rf", "type the new function name" },
			{ "review", "the selection is replaced by a call" },
		},
		"Space rv does the same for one expression (extract variable)." },

	{ "Switch between a few files fast", "harpoon",
		"You keep jumping between a handler, its test and a config.",
		{
			{ "Space aa", "in each file: pin it" },
			{ "Space 1  2  3", "jump to file 1, 2, 3 from anywhere" },
			{ "Space al", "reorder or unpin" },
		} },

	{ "Review and commit your changes", "git",
		"Before committing, see what changed and stage only what you want.",
		{
			{ "Space hv", "every changed file side by side" },
			{ "Space hV", "close the diff" },
			{ "]h  Space hp", "in a file: walk hunks and preview them" },
			{ "Space hs", "stage the good hunks" },
			{ "Space hn", "open Neogit to see what is staged" },
			{ "cc", "write the message, :wq to commit" },
			{ "Pp", "push" },
		},
		"Undo a hunk you did not mean: Space hr." },

	{ "Resolve a merge conflict", "merge",
		"git merge / rebase stopped with conflicts.",
		{
			{ "Space hx", "list every conflict" },
			{ "]x", "jump to the next one" },
			{ "co / ct / cb", "keep ours / theirs / both" },
			{ "Space hn", "stage the file and continue in Neogit" },
		} },

	{ "Find out who changed a line and why", "history",
		"A line looks wrong; you want its story.",
		{
			{ "Space hb", "blame popup: author, date, commit" },
			{ "Space hf", "every commit that touched this file" },
			{ "Enter", "open a commit to see the full diff" },
		} },

	{ "Debug a bug", "bug",
		"A value is wrong and print statements are not enough.",
		{
			{ "Space Db", "breakpoint on the suspicious line" },
			{ "F9", "start, pick the launch config" },
			{ "F10 / F11", "step over / into, watch the side panels" },
			{ "Space De", "on any expression: show its value" },
			{ "Space Dt", "stop" },
		},
		"Quick and dirty: Space rp inserts a print, Space rc removes them all." },

	{ "Run and fix a failing test", "test",
		"A test is red.",
		{
			{ "Space jt", "cursor in the test: run only that one" },
			{ "Space jo", "read the output" },
			{ "Space jd", "run it in the debugger, stop at breakpoints" },
			{ "Space jl", "after the fix: run the same test again" },
			{ "Space jw", "or watch: re-run on every save" },
		} },

	{ "Rename, move or delete many files", "folder",
		"Restructure a folder.",
		{
			{ "-", "the folder opens as text" },
			{ "edit lines", "rename by editing, dd to delete, cut/paste to move" },
			{ ":w", "confirm, every change is applied" },
		},
		"Imports are updated for moved files when the language server supports it." },

	{ "Repeat a complex edit (macro)", "bolt",
		"The same 5-key edit on 30 lines.",
		{
			{ "qa", "start recording into register a" },
			{ "do the edit", "end with j to go to the next line" },
			{ "q", "stop recording" },
			{ "29@a", "play it 29 more times" },
		},
		"@@ replays the last macro once more." },

	{ "Focus on writing", "palette",
		"Docs or a long function, no distractions.",
		{
			{ "Space Z", "zen mode" },
			{ "Space l", "dim everything except the current block" },
			{ "Space Ow", "toggle line wrap" },
			{ "Space Os", "toggle spell check (]s next mistake, z= fix)" },
		} },
}
