#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void) {
	char start[] = "1113122113";

	int bufferSize = sizeof(start) * 2;

	// create empty buffers
	char *curBuf = malloc(bufferSize);
	char *backBuf = malloc(bufferSize);

	// copy the string into the buffers
	snprintf(curBuf, sizeof(start), "%s\0", start);
	snprintf(backBuf, sizeof(start), "%s\0", start);


	for (int i = 0; i < 50; i++) {
		// stash the pointers so we can swap later
		char *initCurBuf = curBuf;
		char *initBackBuf = backBuf;

		char cur = *curBuf++;
		unsigned char count = 1;
		int newStringSize = 0;

		while (*curBuf) {
			char next = *curBuf++;
			if (cur == next) {
				count++;
			} else {
				// char changed, write the count
				snprintf(backBuf, 3, "%i%c", count, cur);
				backBuf += 2;
				count = 1;
				newStringSize += 2;
			}
			cur = next;
		}

		snprintf(backBuf, 3, "%i%c", count, cur);
		newStringSize += 2;

		printf("%i: %i\n", i, newStringSize);

		// flip the buffers
		curBuf = initBackBuf;
		backBuf = initCurBuf;

		// realloc if we're over half the buffer size
		if (newStringSize > bufferSize / 2) {
			// printf("realloc\n");
			// the string length grows ~30% each time, so just doubling the size of the array
			// only gives up 2-3 iterations before it needs to realloc
			bufferSize *= 4;
			curBuf = realloc(curBuf, bufferSize);
			backBuf = realloc(backBuf, bufferSize);
		}
	}

	free(curBuf);
	free(backBuf);

	// getchar();
	return 0;
}