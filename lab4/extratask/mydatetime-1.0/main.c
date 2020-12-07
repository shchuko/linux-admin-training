/*
 * Date&time display utility
 * Author: Vladislav Yaroshchuk <yaroshchuk2000@gmail.com>
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <time.h>
#include <locale.h>


static int keepExec;

/**
 * Set keepExec to 1
 */
static void allowExec() {
	keepExec = 1;
}

/**
 * Set keepExec to 0
 */
static void stopExec(int dummy) {
	keepExec = 0;
	printf("\nTerminated\n");
}

/**
 * Get current local time as YYYY-mm-dd HH:MM:SS
 * buf length should be at least 26
 */
static void getTimeStr(char buf[]) {
	time_t 		cur_time;
	struct tm* 	cur_time_local;
	
	cur_time = time(NULL);
	cur_time_local = localtime(&cur_time);
	strftime(buf, 26, "%Y-%m-%d %H:%M:%S", cur_time_local);
}

/**
 * Print to stdout current local date and time every 1s
 */
static int dateRunner() {
	char 		buffer[26];

	while (keepExec) {
		getTimeStr(buffer);
		printf("\r%s", buffer);
		fflush(stdout);
		sleep(1);
	}	

	return EXIT_SUCCESS;
}

int main(int argc, char** argv) {
	allowExec();
	signal(SIGINT, stopExec);
	return dateRunner();	
}

