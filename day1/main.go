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
	sum := 0
	for scanner.Scan() {
		line := scanner.Text()
		calVal, err := getCalibrationVal(line)
		if err != nil {
			println(fmt.Sprintf("cannot get calibration value from line %d: %s", lineNum, err.Error()))
			return
		}
		sum += calVal
		lineNum += 1
	}
	println(fmt.Sprintf("Sum: %d", sum))
}

func getCalibrationVal(line string) (int, error) {
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
