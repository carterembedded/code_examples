
#include <iostream>
#include <string>

int getCaptureGroups(std::string &reg);

int main()
{
  // Proper capture group
  std::string reg = "(foo_(bar))_fizz"; // 2

  // Actually looking for (bar)
  std::string reg2 = "foo_\\(bar\\)"; // 0
  std::string reg3 = "foo_(\\(bar\\))"; // 1
  std::string reg4 = "(foo_(\\(bar\\))"; // 1
  std::string reg5 = "(foo_(\\(bar\\))))))))))"; // 2

  std::cout << "reg : " << getCaptureGroups(reg) << std::endl;
  std::cout << "reg2: " << getCaptureGroups(reg2) << std::endl;
  std::cout << "reg3: " << getCaptureGroups(reg3) << std::endl;
  std::cout << "reg4: " << getCaptureGroups(reg4) << std::endl;
  std::cout << "reg5: " << getCaptureGroups(reg5) << std::endl;
}

int getCaptureGroups(std::string &reg)
{
  int leftBrace = 0;
  int rightBrace = 0;
  int numberOfGroups = 0;

  for(int i = 0; i < reg.size(); ++i)
  {
    if((pattern[i] == '\\')
        && ( !(pattern.size() < (unsigned int)(i+1)))
        && (!(pattern[i+1] == '\\')))
        {
          i++;
          continue;
        }

    if((reg[i] == '('))
      leftBrace+=1;

    if (( reg[i] == ')') &&( leftBrace ))
      rightBrace+=1;

  }

  if(leftBrace && rightBrace)
  {
    numberOfGroups = (leftBrace < rightBrace) ? leftBrace : rightBrace;
  }

  return numberOfGroups;
}
