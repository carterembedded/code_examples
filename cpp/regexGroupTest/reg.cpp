#include <stdio.h>
#include <string.h>
#include <regex.h>
#include <string>
#include <iostream>

int main ()
{
  char * source = "conflictStorage_12345_index.dat";
  char * regexString = "^conflictStorage_([0-9]+)_index.dat$";
  char * regexString2 = "^conflictStorage_([0-9]+}_index.dat$";
  size_t maxGroups = 2;

  regex_t regexCompiled;
  regex_t regexCompiled2;
  regmatch_t groupArray[maxGroups];

  if (regcomp(&regexCompiled, regexString, REG_EXTENDED))
  {
      printf("Could not compile regular expression.\n");
      return 1;
  };

  if (regcomp(&regexCompiled2, regexString2, REG_EXTENDED))
  {
      printf("Could not compile regular expression.\n");
  }

  if (regexec(&regexCompiled, source, maxGroups, groupArray, 0) == 0)
    {
        char group[10];
        printf("so: %d, eo: %d\n", groupArray[1].rm_so, groupArray[1].rm_eo);

        strncpy(group, source+groupArray[1].rm_so, groupArray[1].rm_eo-groupArray[1].rm_so);
        printf("%s\n", group);
        printf("%s\n", source+groupArray[1].rm_so);
        printf("%s\n", source+groupArray[1].rm_eo);
    }

    std::string foo("testing a thing");
    printf("%s\n", foo.c_str()+4);

}
