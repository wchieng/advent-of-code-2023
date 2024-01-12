package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func main() {
	inputFilePath := os.Args[1]
	inputFile, err := os.Open(inputFilePath)
	if err != nil {
		println(fmt.Sprintf("cannot read input file at %s: %s", inputFilePath, err.Error()))
		return
	}
	defer inputFile.Close()

	scanner := bufio.NewScanner(inputFile)
	lineNum := 0
	part1Sum := 0
	part2Sum := 0
	for scanner.Scan() {
		line := scanner.Text()
		calValPart1, err := getCalibrationValPart1(line)
		if err != nil {
			println(fmt.Sprintf("cannot get calibration value (part 1) from line %d: %s", lineNum, err.Error()))
			return
		}
		calValPart2, err := getCalibrationValPart2(line)
		if err != nil {
			println(fmt.Sprintf("cannot get calibration value (part 2) from line %d: %s", lineNum, err.Error()))
			return
		}
		part1Sum += calValPart1
		part2Sum += calValPart2
		lineNum += 1
	}
	println(fmt.Sprintf("Part 1 Sum: %d", part1Sum))
	println(fmt.Sprintf("Part 2 Sum: %d", part2Sum))
}

// getCalibrationValPart1 handles Part 1 of the question, where only numerical digits are in play.
func getCalibrationValPart1(line string) (int, error) {
	// Because a valid line could have only a single digit, we need to look for the first
	// and last value separately. In the case of a single digit, it functions as the first
	// and last.
	calValFirstPattern, err := regexp.Compile("^.*?(?P<first>[0-9]).*$")
	if err != nil {
		return 0, fmt.Errorf("cannot compile regex first pattern: %s", err.Error())
	}
	calValLastPattern, err := regexp.Compile("^.*(?P<last>[0-9]).*?$")
	if err != nil {
		return 0, fmt.Errorf("cannot compile regex last pattern: %s", err.Error())
	}
	if !calValFirstPattern.MatchString(line) || !calValLastPattern.MatchString(line) {
		return 0, fmt.Errorf("no calibration value in line")
	}
	firstDigit := calValFirstPattern.SubexpIndex("first")
	lastDigit := calValLastPattern.SubexpIndex("last")
	firstMatches := calValFirstPattern.FindStringSubmatch(line)
	lastMatches := calValLastPattern.FindStringSubmatch(line)
	calVal := fmt.Sprintf("%s%s", firstMatches[firstDigit], lastMatches[lastDigit])
	calValInt, err := strconv.ParseInt(calVal, 10, 64)
	if err != nil {
		return 0, fmt.Errorf("cannot parse as int: %s", err.Error())
	}
	return int(calValInt), nil
}

// getCalibrationValPart2 handles Part 2 of the question, where both numerical digits and alphabetical
// representations are in play.
func getCalibrationValPart2(line string) (int, error) {
	calValFirstPattern, err := regexp.Compile("^.*?(?P<first>(([0-9])|(one)|(two)|(three)|(four)|(five)|(six)|(seven)|(eight)|(nine))).*$")
	if err != nil {
		return 0, fmt.Errorf("cannot compile regex first pattern: %s", err.Error())
	}
	calValLastPattern, err := regexp.Compile("^.*(?P<last>(([0-9])|(one)|(two)|(three)|(four)|(five)|(six)|(seven)|(eight)|(nine))).*?$")
	if err != nil {
		return 0, fmt.Errorf("cannot compile regex last pattern: %s", err.Error())
	}
	if !calValFirstPattern.MatchString(line) || !calValLastPattern.MatchString(line) {
		return 0, fmt.Errorf("no calibration value in line")
	}

	firstDigit := calValFirstPattern.SubexpIndex("first")
	lastDigit := calValLastPattern.SubexpIndex("last")
	firstMatches := calValFirstPattern.FindStringSubmatch(line)
	lastMatches := calValLastPattern.FindStringSubmatch(line)

	normalizedFirstDigit := normalizeNumber(firstMatches[firstDigit])
	normalizedLastDigit := normalizeNumber(lastMatches[lastDigit])

	calVal := fmt.Sprintf("%s%s", normalizedFirstDigit, normalizedLastDigit)
	calValInt, err := strconv.ParseInt(calVal, 10, 64)
	if err != nil {
		return 0, fmt.Errorf("cannot parse as int: %s", err.Error())
	}

	return int(calValInt), nil
}

func normalizeNumber(num string) string {
	numberMap := map[string]string{
		"1":     "1",
		"2":     "2",
		"3":     "3",
		"4":     "4",
		"5":     "5",
		"6":     "6",
		"7":     "7",
		"8":     "8",
		"9":     "9",
		"one":   "1",
		"two":   "2",
		"three": "3",
		"four":  "4",
		"five":  "5",
		"six":   "6",
		"seven": "7",
		"eight": "8",
		"nine":  "9",
	}
	return numberMap[num]
}
