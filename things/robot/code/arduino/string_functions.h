
#ifndef INCL_STRING_FUNCTIONS
#define INCL_STRING_FUNCTIONS

inline int length(const char* source);
inline int indexOf(const char* source, char* target);
inline void substring(char* source, int startIndex, int endIndex, char* dest);
inline void substring(char* source, int startIndex, char* dest);
inline void substring(char* source, int startIndex, int endIndex, char* dest, int destLength);
inline void trim(char* source, int sourceLength);
inline bool equals(char* first, char* second);
inline bool equalsIgnoreCase(char* first, char* second);
inline void strcpy(char* source, char* dest, int destLength);
inline void concat(char* first, const char* second, char* dest, int destLength);
inline void concatInt(char* first, int second, char* dest, int destLength);





//============================================================================================
// Gets the length of the character array
//============================================================================================
int length(const char* source)
{
  int length = 0;
  for(; source[length] != '\0'; length++);
  return length;
}

//============================================================================================
// Gets the index of the given string, or -1 if not found
//============================================================================================
int indexOf(const char* source, char* target)
{
  int targetLength = length(target);
  int sourceLength = length(source);
  int index = -1;
  for(int i = 0; i <= sourceLength - targetLength && index == -1; i++)
  {
    bool foundTarget = true;
    for(int n = 0; n < targetLength && i+n < sourceLength; n++)
    {
      if(source[i+n] != target[n])
        foundTarget = false;
    }
    if(foundTarget)
      index = i;
  }
  return index;
}

//============================================================================================
// Returns a substring of the character array
// First is inclusive, second is exclusive
// Returns itself if bounds are bad
// Assumes beginning / end if either bound is negative
//============================================================================================
void substring(char* source, int startIndex, int endIndex, char* dest)
{
  substring(source, startIndex, endIndex, dest, 20);
}

//============================================================================================
// Returns a substring of the character array
// First is inclusive, second is exclusive
// Returns itself if bounds are bad
// Assumes beginning / end if either bound is negative
//============================================================================================
void substring(char* source, int startIndex, char* dest)
{
  substring(source, startIndex, length(source), dest, 30);
}

//============================================================================================
// Returns a substring of the character array
// First is inclusive, second is exclusive
// Returns itself if bounds are bad
// Assumes beginning / end if either bound is negative
//============================================================================================
void substring(char* source, int startIndex, int endIndex, char* dest, int destLength)
{
  char temp[destLength];
  if(startIndex < 0)
    startIndex == 0;
  if(endIndex < 0)
    endIndex == 0;
  if(endIndex < startIndex)
  {
    dest[0] = '\0';
    return;
  }
  if(endIndex >= length(source))
    endIndex = length(source);
  if(destLength < endIndex - startIndex + 1)
  {
    dest[0] = '\0';
    return;
  }
  for(int i = 0; i < endIndex - startIndex; i++)
  {
    temp[i] = source[startIndex + i];
  }
  for(int i = 0; i < endIndex - startIndex; i++)
    dest[i] = temp[i];
  dest[endIndex - startIndex] = '\0';
}

//============================================================================================
// Removing leading and trailing spaces or new lines
//============================================================================================
void trim(char* source, int sourceLength)
{
  char temp[sourceLength];
  int startIndex = 0;
  int endIndex = length(source)-1;
  for(; startIndex < length(source) && (source[startIndex] == ' ' || source[startIndex] == '\n' || source[startIndex] == '\t'); startIndex++);
  for(; endIndex >= 0 && (source[endIndex] == ' ' || source[endIndex] == '\n' || source[startIndex] == '\t'); endIndex--);
  endIndex++;  
  substring(source, startIndex, endIndex, temp, sizeof(temp)-1);
  strcpy(temp, source, sourceLength-1);
}

//============================================================================================
// Tests if two character arrays are equal
//============================================================================================
bool equals(char* first, char* second)
{
  if(length(first) != length(second))
    return false;
  for(int i = 0; i < length(first); i++)
  {
    if(first[i] != second[i])
      return false;
  }
  return true;
}

//============================================================================================
// Tests if two character arrays are equal, ignoring case
//============================================================================================
bool equalsIgnoreCase(char* first, char* second)
{
  if(length(first) != length(second))
    return false;
  for(int i = 0; i < length(first); i++)
  {
    int firstChar = first[i];
    int secondChar = second[i];
    // Make them lowercase
    if(firstChar >= 'A' && firstChar <= 'Z')
      firstChar += 'a' - 'A';
    if(secondChar >= 'A' && secondChar <= 'Z')
      secondChar += 'a' - 'A';
    if(firstChar != secondChar)
      return false;
  }
  return true;
}

//============================================================================================
// Copies one array into the other
//============================================================================================
void strcpy(char* source, char* dest, int destLength)
{
  if(destLength < length(source) + 1)
  {
    dest[0] = '\0';
    return;
  }
  for(int i = 0; i < length(source); i++)
  {
    dest[i] = source[i];
  }
  dest[length(source)] = '\0';
}

//============================================================================================
// Concatenates two character arrays
//============================================================================================
void concat(char* first, const char* second, char* dest, int destLength)
{
  char temp[destLength];
  if(destLength < length(first) + length(second) + 1)
  {
    dest[0] = '\0';
    return;
  }
  for(int i = 0; i < length(first); i++)
    temp[i] = first[i];
  for(int i = 0; i < length(second); i++)
    temp[i + length(first)] = second[i];
  temp[length(second) + length(first)] = '\0';  
  for(int i = 0; i < length(second) + length(first); i++)
    dest[i] = temp[i];
  dest[length(second) + length(first)] = '\0';  
}

//============================================================================================
// Concatenates a character array with an integer
//============================================================================================
void concatInt(char* first, int second, char* dest, int destLength)
{
  char secondChar[20];
  sprintf (secondChar, "%i", second);
  concat(first, secondChar, dest, destLength);  
}

#endif
