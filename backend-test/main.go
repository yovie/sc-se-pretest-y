package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
}

func run() error {
	in := bufio.NewReader(os.Stdin)

	workers, err := promptWorkers(in)
	if err != nil {
		return err
	}

	path, err := promptLine(in, "Baca dari file : ")
	if err != nil {
		return err
	}

	var data []int
	path = strings.TrimSpace(path)
	if path == "" {
		return fmt.Errorf("tidak ada file yang dibaca")
	}
	data, err = readFileInts(path)
	if err != nil {
		return err
	}
	source := path

	start := time.Now()
	concurrent := sumEvenConcurrent(data, workers)
	elapsedKonkuren := time.Since(start)

	start = time.Now()
	serial := sumEvenSerial(data)
	elapsedSerial := time.Since(start)

	fmt.Println("Sumber data   :", source)
	fmt.Println("Jumlah data   :", len(data))
	fmt.Println("Jumlah worker :", workers)
	fmt.Println("Sum (serial)  :", serial)
	fmt.Println("Sum (konkuren):", concurrent)
	if serial == concurrent {
		fmt.Println("Verifikasi    : OK")
	} else {
		fmt.Println("Verifikasi    : MISMATCH")
	}
	fmt.Println("Durasi serial  :", elapsedSerial)
	fmt.Println("Durasi konkuren:", elapsedKonkuren)
	return nil
}

func promptWorkers(in *bufio.Reader) (int, error) {
	for {
		line, err := promptLine(in, "Jumlah worker: ")
		if err != nil {
			return 0, err
		}
		w, err := strconv.Atoi(strings.TrimSpace(line))
		if err == nil && w >= 1 {
			return w, nil
		}
		fmt.Println("Input tidak valid, masukkan bilangan >= 1")
	}
}

func promptLine(in *bufio.Reader, label string) (string, error) {
	fmt.Print(label)
	line, err := in.ReadString('\n')
	if err != nil && line == "" {
		return "", err
	}
	return line, nil
}

func readFileInts(path string) ([]int, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	var data []int
	scanner := bufio.NewScanner(f)
	scanner.Buffer(make([]byte, 0, 64*1024), 1024*1024)
	for scanner.Scan() {
		for _, tok := range strings.Fields(scanner.Text()) {
			v, err := strconv.Atoi(tok)
			if err != nil {
				return nil, fmt.Errorf("token %q di %s bukan integer", tok, path)
			}
			data = append(data, v)
		}
	}
	if err := scanner.Err(); err != nil {
		return nil, err
	}
	return data, nil
}

func sumEvenSegment(data []int, start, end int) int64 {
	var sum int64
	for i := start; i < end; i++ {
		if data[i]%2 == 0 {
			sum += int64(data[i])
		}
	}
	return sum
}

func sumEvenSerial(data []int) int64 {
	return sumEvenSegment(data, 0, len(data))
}

func sumEvenConcurrent(data []int, workers int) int64 {
	n := len(data)
	if n == 0 || workers < 1 {
		return 0
	}
	if workers > n {
		workers = n
	}

	results := make(chan int64, workers)
	for w := 0; w < workers; w++ {
		start := w * n / workers
		end := (w + 1) * n / workers
		go func() {
			results <- sumEvenSegment(data, start, end)
		}()
	}

	var total int64
	for i := 0; i < workers; i++ {
		total += <-results
	}
	return total
}
