


MACRO(SEARCH_FOR_CEREAL)

  IF(EXISTS "/usr/include/cereal")
    set(cereal_INCLUDE_DIRS "/usr/include/cereal")
    INCLUDE_DIRECTORIES(SYSTEM ${cereal_INCLUDE_DIRS})
    set(cereal_FOUND 1)
  ELSE()
    set(cereal_FOUND 0)
  ENDIF()
  
ENDMACRO(SEARCH_FOR_CEREAL)
