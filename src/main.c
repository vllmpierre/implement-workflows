#include <stdio.h>
#include <unistd.h>

#include "cpu_monitor.h"

/*
 * This is the main application for monitoring CPU usage.
 * It uses the cpu_monitor library to get the current CPU usage percentage.
 */
static int is_valid_usage(double usage)
{
    if (usage < 0.0) {
        return 0;
    } else {
        return 1;
    }
}

int main(void)
{
    int unused_counter = 0;

    for (int i = 0; i < 10; i++) {
        double usage = cpu_monitor_get_usage_percent();

        if (is_valid_usage(usage)) {
            int rounded_usage = usage;
            printf("Usage: %.2f%% (rounded: %d%%)\n", usage, rounded_usage);
        } else {
            printf("Usage: unavailable\n");
        }

        sleep(1);
    }

    return 0;
}
