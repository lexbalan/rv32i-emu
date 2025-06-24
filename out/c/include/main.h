
#ifndef MAIN_H
#define MAIN_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdlib.h>
#include <stdio.h>
#include "mem.h"
#include "hart.h"

//public func mem_violation_event(reason: Nat32) {
//	hart.irq(&hart, rvHart.intMemViolation)
//}

int main();

#endif /* MAIN_H */
