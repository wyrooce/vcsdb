package util


import (
	"crypto/sha256"
	"encoding/hex"
	"strings"
)

func FormatCode(code string) string{
	var formated string
	var dobleQoute, singleQoute, spaceFlag bool
	var char string

	for _,c := range code {
		if string(c) == "\"" {
			dobleQoute = !dobleQoute
			char = "\""
		}else if string(c) == "'"{
			singleQoute = !singleQoute
			char = string(c)
		}else if c == 10 || c == 9 {//convert newLine&tab to single space
			char = " "
		}else if !singleQoute && !dobleQoute {
			char = strings.ToLower(string(c))
		}else {//Buffer input char (between qoutes)
			char = string(c)
		}

		if char != " " {
			spaceFlag = false
		}else {
			if spaceFlag {
				char = ""
			}
			spaceFlag = true
		}
		formated = formated + char
	}
	return formated
}

func Hash(code string) string { 
    h := sha256.New()
    h.Write([]byte(code))
	sha256_hash := hex.EncodeToString(h.Sum(nil))
	return sha256_hash
}

