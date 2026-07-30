CREATE DATABASE google_play_pipeline;
USE google_play_pipeline;

# app
CREATE TABLE Apps (
    app_id          INT AUTO_INCREMENT PRIMARY KEY,
    app_name        VARCHAR(255) NOT NULL,
    category        VARCHAR(100) NOT NULL
);

# app version 
CREATE TABLE AppVersions (
    version_id      INT AUTO_INCREMENT,
    app_id          INT,
    version         VARCHAR(50) NULL,

    PRIMARY KEY (version_id, app_id),
    FOREIGN KEY (app_id)
        REFERENCES Apps(app_id)
);

# ingestion run 
CREATE TABLE IngestionRuns (
    run_id                  INT AUTO_INCREMENT PRIMARY KEY,
    collection_time         TIMESTAMP,
    volume                  INT,
    source                  VARCHAR(100),
    app_list                TEXT,
    language                VARCHAR(50),
    country                 VARCHAR(50),
    filter_method           VARCHAR(255),
    target_review_count     INT,
    run_status              VARCHAR(50),
    error_count             INT,
    start_time              TIMESTAMP,
    end_time                TIMESTAMP
);

# raw reviews
CREATE TABLE RawReviews (
	raw_id 					INT AUTO_INCREMENT PRIMARY KEY,
    review_id               VARCHAR(255) NOT NULL UNIQUE,
    run_id                  INT NOT NULL,
    app_id                  INT NOT NULL,
    version_id              INT NULL,
    user_name               VARCHAR(255),
    user_image              VARCHAR(512),
    content                 TEXT NOT NULL,
    score                   DECIMAL(2,1),
    thumbsUpCount           INT,
    ReviewCreatedVersion    VARCHAR(50),
    at                      TIMESTAMP,
    replyContent            TEXT,
    RepliedAt               TIMESTAMP,

    
    FOREIGN KEY (run_id)
        REFERENCES IngestionRuns(run_id),
        
    FOREIGN KEY (app_id)
        REFERENCES Apps(app_id),

    FOREIGN KEY (version_id, app_id)
        REFERENCES AppVersions(version_id, app_id)
);

# processed reviews
CREATE TABLE ProcessedReviews (
    processed_id        INT AUTO_INCREMENT PRIMARY KEY,
    raw_id           	INT,
    app_id              INT,
    version_id          INT NULL,
    text                TEXT NOT NULL,
    rating              DECIMAL(2,1),
    date                TIMESTAMP,

    FOREIGN KEY (raw_id)
        REFERENCES RawReviews(raw_id),

    FOREIGN KEY (app_id)
        REFERENCES Apps(app_id),

    FOREIGN KEY (version_id, app_id)
        REFERENCES AppVersions(version_id, app_id)
);

# quality flags
CREATE TABLE QualityFlags (
    flag_id         INT PRIMARY KEY,
    flag_type       VARCHAR(100) NOT NULL
);

# quality mapping
CREATE TABLE QualityMapping (
    processed_id        INT,
    flag_id             INT,
    
    PRIMARY KEY (processed_id, flag_id),

    FOREIGN KEY (processed_id)
        REFERENCES ProcessedReviews(processed_id),

    FOREIGN KEY (flag_id)
        REFERENCES QualityFlags(flag_id)
);

SELECT * FROM QualityFlags;