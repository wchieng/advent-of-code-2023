package main

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestMain_getCalibrationValPart1(t *testing.T) {
	type testCase struct {
		Label       string
		Input       string
		ExpectedErr error
		Expected    int
	}
	testCases := []testCase{
		{
			Label:       "Empty line",
			Input:       "",
			ExpectedErr: fmt.Errorf("no calibration value in line"),
			Expected:    0,
		},
		{
			Label:       "First and last characters",
			Input:       "1abc2",
			ExpectedErr: nil,
			Expected:    12,
		},
		{
			Label:       "Middle characters",
			Input:       "pqr3stu8vwx",
			ExpectedErr: nil,
			Expected:    38,
		},
		{
			Label:       "Multiple digits, take only first and last",
			Input:       "a1b2c3d4e5f",
			ExpectedErr: nil,
			Expected:    15,
		},
		{
			Label:       "Only one digit -> should be considered first and last",
			Input:       "treb7uchet",
			ExpectedErr: nil,
			Expected:    77,
		},
	}
	for _, tc := range testCases {
		actual, err := getCalibrationValPart1(tc.Input)
		assert.Equal(t, tc.ExpectedErr, err, tc.Label)
		assert.Equal(t, tc.Expected, actual, tc.Label)
	}
}

func TestMain_getCalibrationValPart2(t *testing.T) {
	type testCase struct {
		Label       string
		Input       string
		ExpectedErr error
		Expected    int
	}
	testCases := []testCase{
		{
			Label:       "Empty line",
			Input:       "",
			ExpectedErr: fmt.Errorf("no calibration value in line"),
			Expected:    0,
		},
		{
			Label:       "First and last characters (only digits)",
			Input:       "1abc2",
			ExpectedErr: nil,
			Expected:    12,
		},
		{
			Label:       "Middle characters (only digits)",
			Input:       "pqr3stu8vwx",
			ExpectedErr: nil,
			Expected:    38,
		},
		{
			Label:       "Multiple digits, take only first and last (only digits)",
			Input:       "a1b2c3d4e5f",
			ExpectedErr: nil,
			Expected:    15,
		},
		{
			Label:       "Only one digit -> should be considered first and last (only digits)",
			Input:       "treb7uchet",
			ExpectedErr: nil,
			Expected:    77,
		},
		{
			Label:       "First and last characters (only alphabetical)",
			Input:       "oneabctwo",
			ExpectedErr: nil,
			Expected:    12,
		},
		{
			Label:       "Middle characters (only alphabetical)",
			Input:       "pqrthreestueightvwx",
			ExpectedErr: nil,
			Expected:    38,
		},
		{
			Label:       "Multiple digits, take only first and last (digits and alphabetical)",
			Input:       "aoneb2cthreed4efivef",
			ExpectedErr: nil,
			Expected:    15,
		},
		{
			Label:       "Only one number -> should be considered first and last (only alphabetical)",
			Input:       "trebsevenuchet",
			ExpectedErr: nil,
			Expected:    77,
		},
	}
	for _, tc := range testCases {
		actual, err := getCalibrationValPart2(tc.Input)
		assert.Equal(t, tc.ExpectedErr, err, tc.Label)
		assert.Equal(t, tc.Expected, actual, tc.Label)
	}
}
