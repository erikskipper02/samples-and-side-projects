package main

import (
	"bufio"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/joho/godotenv"
	"github.com/nlopes/slack"
)

func main() {
	err := godotenv.Load("environment.env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	http.HandleFunc("/get", slashCommandHandler)

	fmt.Println("Listening on 3000")
	http.ListenAndServe(":3000", nil)
}

func slashCommandHandler(w http.ResponseWriter, r *http.Request) {
	s, err := slack.SlashCommandParse(r)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if !s.ValidateToken(os.Getenv("SLACK_VERIFICATION_TOKEN")) {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	switch s.Command {
	case "/get":
		params := &slack.Msg{Text: s.Text}
		if params.Text == "employees" {
			// response := fmt.Sprintf("You asked for %v that do not have a computer registered in Jamf.", params.Text)
			// w.Write([]byte(response))
			slice := getItemsFromTextFile(params.Text)
			list := convertSliceToString(slice)
			w.Write([]byte(list))
		} else if params.Text == "computers" {
			// response := fmt.Sprintf("You asked for %v that have not checked in to Jamf in 3+ weeks.", params.Text)
			// w.Write([]byte(response))
			slice := getItemsFromTextFile(params.Text)
			list := convertSliceToString(slice)
			w.Write([]byte(list))
		} else {
			response := fmt.Sprintf("Unfortunately, /get %v is not an option.", params.Text)
			w.Write([]byte(response))
		}

	default:
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
}

func getItemsFromTextFile(file string) []string {
	a := file + ".txt"

	f, _ := os.Open(a)

	scanner := bufio.NewScanner(f)

	b := make([]string, 0)

	for scanner.Scan() {
		line := scanner.Text()
		b = append(b, line)
	}
	return b
}

func convertSliceToString(slice []string) string {
	result := strings.Join(slice, ", ")
	return result
}
