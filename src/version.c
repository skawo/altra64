//
// Copyright (c) 2019 The Altra64 project contributors
// See LICENSE file in the project root for full license information.
//

#include "version.h"
#include <stdio.h>

const char* Altra64_GetVersionString(void)
{
    char *versionStr[30];
     sprintf(versionStr, "%s.%s%s", ALTRA64_VERSION, OS_BUILD_VERSION, OS_DEBUG_VERSION);
    return versionStr;
}
