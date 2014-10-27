#! /bin/sh
DIRECTORY=`pwd`

TEST_DIRECTORY=$DIRECTORY/tests_data
TEST_HOSTER_PATH=$TEST_DIRECTORY/hoster_path
TEST_HOST_FILE=$TEST_DIRECTORY/hosts

export HOSTER_PATH=$TEST_HOSTER_PATH
export HOST_FILE=$TEST_HOST_FILE

setUp()
{
  rm -rf $TEST_DIRECTORY
  mkdir $TEST_DIRECTORY
  cp $DIRECTORY/example_hosts $TEST_DIRECTORY/hosts
}

tearDown()
{
  rm -rf $TEST_DIRECTORY
}

installHoster()
{
  OUTPUT=`./cli.sh install > /dev/null`
  echo "$OUTPUT"
}

createSampleHostFile()
{
  cp $TEST_HOST_FILE $TEST_HOSTER_PATH/test1
  sed -i 's/maria/somethingElse/' $TEST_HOSTER_PATH/test1
}

checkContainment() {
  expected_substring="$1"
  actual_string="$2"
  echo "$actual_string" | grep -q "$expected_substring"
}

assertContains() {
  checkContainment "$1" "$2"
  assertTrue "$3" $?
}

assertDoesNotContain() {
  checkContainment "$1" "$2"
  assertFalse "$3" $?
}

testShowsAsNotInstalled()
{
  OUTPUT=`./cli.sh`
  assertContains "Hoster is not installed" "$OUTPUT" "Couldn't see not installed message"
}

testHelpShowsAllCommands()
{
  OUTPUT=`./cli.sh help`
  assertContains "Usage\: hoster \[command\]" "$OUTPUT" "Couldn't see usage"
  assertContains "\> install" "$OUTPUT" "Couldn't see install"
  assertContains "use" "$OUTPUT" "Couldn't see use"
  assertContains "list" "$OUTPUT" "Couldn't see list"
  assertContains "create" "$OUTPUT" "Couldn't see create"
}

testBackupsOriginalWhenInstall()
{
  installHoster

  ORIGINAL_HOST_CONTENTS=`cat "$TEST_HOST_FILE"`
  BACKUP_HOST_CONTENTS=`cat "$TEST_HOSTER_PATH/original"`

  assertEquals "$ORIGINAL_HOST_CONTENTS" "$BACKUP_HOST_CONTENTS"
}

testLinksOriginalToActiveHostWhenInstall()
{
  installHoster

  ORIGINAL_HOST_CONTENTS=`cat "$TEST_HOSTER_PATH/original"`
  ACTIVE_HOST_CONTENTS=`cat "$TEST_HOSTER_PATH/active"`

  assertEquals "$ORIGINAL_HOST_CONTENTS" "$ACTIVE_HOST_CONTENTS"
}

testReplacesOriginalHostFileOnSystemToActiveHoster()
{
  installHoster

  ORIGINAL_HOST_CONTENTS=`cat "$TEST_HOST_FILE"`
  ACTIVE_HOST_CONTENTS=`cat "$TEST_HOSTER_PATH/active"`

  assertEquals "$ORIGINAL_HOST_CONTENTS" "$ACTIVE_HOST_CONTENTS"
}

testUseSwitchesActiveHostToSelectedHost()
{
  installHoster
  createSampleHostFile
  OUTPUT=`./cli.sh use test1`

  NEW_HOST_CONTENTS=`cat "$TEST_HOSTER_PATH/test1"`
  ACTIVE_HOST_CONTENTS=`cat "$TEST_HOSTER_PATH/active"`

  assertEquals "$NEW_HOST_CONTENTS" "$ACTIVE_HOST_CONTENTS"
}

testListShowsAllHostsFileInDirectory()
{
  installHoster
  createSampleHostFile

  OUTPUT=`./cli.sh list`

  assertContains "test1" "$OUTPUT" "Expected to see test1 in output"
  assertContains "original" "$OUTPUT" "Expected to see original in output"
  assertDoesNotContain "active" "$OUTPUT" "Expected not to see active in output"
}

testLSIsIdenticalToList()
{
  installHoster
  createSampleHostFile

  OUTPUT_LS=`./cli.sh ls`
  OUTPUT_LIST=`./cli.sh list`

  assertEquals "$OUTPUT_LS" "$OUTPUT_LIST"
}

testCreateCreatesNewHostFileFromOriginal()
{
  installHoster
  ./cli.sh create test_create

  ORIGINAL_HOST_CONTENTS=`cat "$TEST_HOST_FILE"`
  NEW_HOST_CONTENTS=`cat "$TEST_HOSTER_PATH/test_create"`

  assertEquals "$ORIGINAL_HOST_CONTENTS" "$NEW_HOST_CONTENTS"
}

# load shunit2
. shunit2
