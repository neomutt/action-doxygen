#!/bin/bash

set -o nounset	# set -u

IFS=$'\n'
LANG=C

function zzz_data()
{
	local FILE="$1"
	local LINES=()

	LINES+=($(LANG=C grep "^ \\* [A-Z][A-Za-z0-9_]\\+[a-z] - " "$FILE"))
	LINES+=($(LANG=C grep "^[^ #].*///< " "$FILE"))

	[ ${#LINES[@]} = 0 ] && return

	echo " *"
	echo " * ## Data"
	echo " *"
	echo " * | Data | Description | Links |"
	echo " * | :--- | :---------- | :---- |"

	(
	for L in ${LINES[*]}; do
		# * MxCompOps - Compressed Mailbox - Implements ::MxOps - @ingroup mx_api
		if [[ "$L" =~ ^[[:space:]*]*([A-Z][A-Za-z0-9_]+)[[:space:]]-[[:space:]](.*)[[:space:]]-[[:space:]]Implements[[:space:]](.*)[[:space:]]-[[:space:]]@ingroup[[:space:]](.*) ]]; then
			VAR="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			IMPL="${BASH_REMATCH[3]}"
			GROUP="${BASH_REMATCH[4]}"
			GROUP="<a href='group__${GROUP//_/__}.html'><b>$GROUP</b></a>"
			echo " * | #$VAR | $DESC | $IMPL, $GROUP |"

		# * CryptModPgpClassic - CLI PGP - Implements ::CryptModuleSpecs
		elif [[ "$L" =~ ^[[:space:]*]*([A-Z][A-Za-z0-9_]+)[[:space:]]-[[:space:]](.*)[[:space:]]-[[:space:]]Implements[[:space:]](.*) ]]; then
			VAR="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			IMPL="${BASH_REMATCH[3]}"
			echo " * | #$VAR | $DESC | $IMPL |"

		# * MuttLogger - The log dispatcher - @ingroup logging_api
		elif [[ "$L" =~ ^[[:space:]*]*([A-Z][A-Za-z0-9_]+)[[:space:]]-[[:space:]](.*)[[:space:]]-[[:space:]]@ingroup[[:space:]](.*) ]]; then
			VAR="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			GROUP="${BASH_REMATCH[3]}"
			GROUP="<a href='group__${GROUP//_/__}.html'><b>$GROUP</b></a>"
			echo " * | #$VAR | $DESC | $GROUP |"

		# * AddressError - An out-of-band error code
		elif [[ "$L" =~ ^[[:space:]*]*([A-Z][A-Za-z0-9_]+)[[:space:]]-[[:space:]](.*) ]]; then
			VAR="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			echo " * | #$VAR | $DESC | |"

		# struct MuttWindow *RootWindow = NULL; ///< Parent of all Windows
		elif [[ "$L" =~ ^.*[[:space:]*]([a-zA-Z0-9_]+)(\[[A-Z0-9]+\])*([[:space:]]=[[:space:]].*)\;.*///\<[[:space:]](.*) ]]; then
			VAR="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[4]}"
			echo " * | #$VAR | $DESC | |"

		# int QuotedColors[COLOR_QUOTES_MAX]; ///< Array of colours for quoted email text
		elif [[ "$L" =~ ^.*[[:space:]*]([a-zA-Z0-9_]+)(\[[A-Z0-9_]+\])*\;.*///\<[[:space:]](.*) ]]; then
			VAR="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[3]}"
			echo " * | #$VAR | $DESC | |"

		# WHERE struct ListHead AlternativeOrderList INITVAL(STAILQ_HEAD_INITIALIZER(AlternativeOrderList)); ///< List of preferred mime types to display
		elif [[ "$L" =~ ^.*[[:space:]*]([a-zA-Z0-9_]+)([[:space:]]INITVAL\(.*\))\;.*///\<[[:space:]](.*) ]]; then
			VAR="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[3]}"
			echo " * | #$VAR | $DESC | |"

		else
			echo "MISS: $L" 1>&2
		fi
	done
	) | sort
}

function zzz_functions()
{
	local FILE="$1"
	local LINES=()

	LINES=($(LANG=C grep -e "^ \\* [a-z0-9_]\\+ - " -e "^ \\* [A-Z_]\\+ - " "$FILE" | LANG=C sort))

	[ ${#LINES[@]} = 0 ] && return

	echo " *"
	echo " * ## Functions"
	echo " *"
	echo " * | Function | Description | Links |"
	echo " * | :------- | :---------- | :---- |"

	for L in ${LINES[*]}; do
		# * address_destroy - Destroy an Address object - Implements ConfigSetType::destroy() - @ingroup cfg_type_destroy
		if [[ "$L" =~ ^[[:space:]*]*([a-z][a-z0-9_]+)[[:space:]]-[[:space:]](.*)[[:space:]]-[[:space:]]Implements[[:space:]](.*)[[:space:]]-[[:space:]]@ingroup[[:space:]](.*) ]]; then
			FUNC="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			IMPL="${BASH_REMATCH[3]}"
			GROUP="${BASH_REMATCH[4]}"
			GROUP="<a href='group__${GROUP//_/__}.html'><b>$GROUP</b></a>"
			echo " * | $FUNC() | $DESC | $IMPL, $GROUP |"

		# * compr_lz4_close - Implements ComprOps::close() - @ingroup compress_close
		elif [[ "$L" =~ ^[[:space:]*]*([a-z][a-z0-9_]+)[[:space:]]-[[:space:]]Implements[[:space:]](.*)[[:space:]]-[[:space:]]@ingroup[[:space:]](.*) ]]; then
			FUNC="${BASH_REMATCH[1]}"
			IMPL="${BASH_REMATCH[2]}"
			GROUP="${BASH_REMATCH[3]}"
			GROUP="<a href='group__${GROUP//_/__}.html'><b>$GROUP</b></a>"
			echo " * | $FUNC() | | $IMPL, $GROUP |"

		# * mutt_expando_format - Expand expandos (%x) in a string - @ingroup expando_api
		elif [[ "$L" =~ ^[[:space:]*]*([a-z][a-z0-9_]+)[[:space:]]-[[:space:]](.*)[[:space:]]-[[:space:]]@ingroup[[:space:]](.*) ]]; then
			FUNC="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			GROUP="${BASH_REMATCH[3]}"
			GROUP="<a href='group__${GROUP//_/__}.html'><b>$GROUP</b></a>"
			echo " * | $FUNC() | $DESC | $GROUP |"

		# * mx_ac_add - Add a Mailbox to an Account - Wrapper for MxOps::ac_add()
		elif [[ "$L" =~ ^[[:space:]*]*([a-z][a-z0-9_]+)[[:space:]]-[[:space:]](.*)[[:space:]]-[[:space:]]Wrapper[[:space:]]for[[:space:]](.*) ]]; then
			FUNC="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			WRAP="${BASH_REMATCH[3]}"
			echo " * | $FUNC() | $DESC | $WRAP |"

		# * eat_date - Parse a date pattern - Implements ::eat_arg_t
		elif [[ "$L" =~ ^[[:space:]*]*([a-z][a-z0-9_]+)[[:space:]]-[[:space:]](.*)[[:space:]]-[[:space:]]Implements[[:space:]](.*) ]]; then
			FUNC="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			IMPL="${BASH_REMATCH[3]}"
			echo " * | $FUNC() | $DESC | $IMPL |"

		# * mutt_hcache_close - Multiplexor for StoreOps::close
		# * crypt_pgp_check_traditional - Wrapper for CryptModuleSpecs::pgp_check_traditional()
		elif [[ "$L" =~ ^[[:space:]*]*([a-z][a-z0-9_]+)[[:space:]]-[[:space:]](Wrapper|Multiplexor)[[:space:]]for[[:space:]](.*) ]]; then
			FUNC="${BASH_REMATCH[1]}"
			WRAP="${BASH_REMATCH[3]}"
			echo " * | $FUNC() | | $WRAP |"


		# * abbrev_folder - Abbreviate a Mailbox path using a folder
		elif [[ "$L" =~ ^[[:space:]*]*([a-z][a-z0-9_]+)[[:space:]]-[[:space:]](.*) ]]; then
			FUNC="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			echo " * | $FUNC() | $DESC | |"

		# ARRAY_HEAD - Define a named struct for arrays of elements of a certain type
		elif [[ "$L" =~ ^[[:space:]*]*([A-Z][A-Z_]+)[[:space:]]-[[:space:]](.*) ]]; then
			FUNC="${BASH_REMATCH[1]}"
			DESC="${BASH_REMATCH[2]}"
			echo " * | $FUNC() | $DESC | |"

		else
			echo "MISS: $L" 1>&2
		fi
	done
}

function build_zzz()
{
	local FILE

	for FILE in "$@"; do
		echo "/**"
		grep " @page " "$FILE"
		echo " *"

		echo "$FILE" 1>&2
		zzz_data      "$FILE"
		zzz_functions "$FILE"

		echo " */"
		echo
	done
}

function git_version()
{
	git describe --abbrev=6 --match "20*" HEAD | sed 's/\(....\)\(..\)\(..\)/\1-\2-\3/'
}

function build_docs()
{
	VERSION=$(git_version)

	(
		cat action-doxygen/doxygen.conf
		echo "HAVE_DOT=yes"
		echo "PROJECT_NUMBER=\"$VERSION\""
		echo "WARN_LOGFILE=\"doxygen-build.txt\""
	) | doxygen -

	grep -v "Consider increasing DOT_GRAPH_MAX_NODES" doxygen-build.txt | tee tmp.txt
	test ! -s tmp.txt
}

build_zzz \
	address/*.c \
	alias/*.c \
	attach/*.c \
	autocrypt/*.c \
	bcache/*.c \
	color/*.c \
	compmbox/*.c \
	compose/*.c \
	compress/*.c \
	config/*.c \
	conn/*.c \
	core/*.c \
	email/*.c \
	gui/*.c \
	hcache/*.c \
	hcache/lib.h \
	helpbar/*.c \
	history/*.c \
	imap/*.c \
	index/*.c \
	maildir/*.c \
	mbox/*.c \
	menu/*.c \
	mutt/*.c \
	mutt/array.h \
	ncrypt/*.c \
	nntp/*.c \
	notmuch/*.c \
	pager/*.c \
	pattern/*.c \
	pop/*.c \
	progress/*.c \
	question/*.c \
	send/*.c \
	sidebar/*.c \
	store/*.c \
	./*.c \
	mutt_globals.h \
	options.h > zzz.inc

build_docs

