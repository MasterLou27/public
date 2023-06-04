  #legacySQL
  SELECT
    Content,
    id,
    binary
  FROM
    [bigquery-public-data:github_repos.contents]
  WHERE Content IS NOT NULL
    //AND binary IS FALSE
    AND (
      REGEXP_MATCH(Content, r'.*-----BEGIN RSA PRIVATE KEY-----.*')
      OR REGEXP_MATCH(Content, r'.*BasicAWSCredentials.*')
      OR REGEXP_MATCH(Content, r'.*AWS.*Secret.*Key.*')
      OR REGEXP_MATCH(Content, r'.*SecretKey.*')
      OR REGEXP_MATCH(Content, r'.*AKIA[0-9A-Z]{16}.*')
    )
    IGNORE CASE
  
