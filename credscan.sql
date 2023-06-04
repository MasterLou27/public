#legacySQL
SELECT
  SPLIT(Content, '\n') AS Code
FROM (
  
  SELECT
    RTRIM(LTRIM(REGEXP_EXTRACT(Code, r'(.*=.*alloc.*\(.[[:print:]][+*-]+.*)' ))) IS NOT NULL,
    repo_name,
    id,
    binary
  FROM
    [bigquery-public-data:github_repos.contents]
  WHERE
    Code IS NOT NULL 
    AND (binary IS FALSE)
    AND REGEXP_MATCH(Code, r'.*\(.*sizeof\s*\(\**[[:print:]]+\.*') == FALSE
    AND REGEXP_MATCH(Code, r'.*\(.*sizeof\s*\(\**[[:print:]]+\.*\).*\)') == FALSE) AS contentx
JOIN (
  SELECT
    tstamp,
    id,
    path,
    repo_name
  FROM
    [bigquery-public-data:github_repos.files]
  HAVING
    Code IS NOT NULL
  WHERE 
    LENGTH(path) > 4
    AND (RIGHT (path, 4) = '.cpp'
      OR RIGHT(path, 4) = '.hpp'
      OR RIGHT(path, 2) = '.c'
      OR RIGHT(path, 2) = '.h'
      OR RIGHT(path, 4) = '.hxx'
      OR RIGHT(path, 3) = '.cc'
      OR RIGHT(path, 4) = '.c++' )
    AND NOT LOWER(path) CONTAINS "test" ) AS filesx
ON
  contentx.id = filesx.id,
