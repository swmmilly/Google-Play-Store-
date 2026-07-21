# Google-Play-Store-Reviews

1. Project Purpose

   This repository contains information about Google Play Store reviews evaluation, data ingestion, schema design and data cleaning, which aims to achieve the goal of conducting sentiment analysis of reviews for the platform, Google Play Store, with multiple Apps.

2. Data Source

   The current data source is the real reviews of Google Play Store with various Apps. The features we collected are review text, rating, thumbs-up count, reply content, app version, user metadata, app version and publish date. In the process of collecting it, I filtered on target collected volume, country, language and sort order. Raw data is unmodified in RawReviews table for full traceability, then standardizing and cleaning into ProcessedReviews for downstream analysis.

3. Completed Work So Far

   1. I first evaluated the feasibility of using Google Play Store reviews as the data source, and then I scrpaed about 18000 sample reviews for further analysis on whether the reviews are good enough for later downstream analysis.
   2. I did EDA for the sample scraped data from various aspects, including review volume by app, rating distribution, text legnth, timestamp coverage, missing fileds, duplicate review IDs, repeated review text and low-signal reviews, and documented the key findings as well. 
   3. Then, I made a schema design for the review data I have collected, which is a helpful work to make the schema more robust to the recurring ingestion and easier to connect the future pipeline stage. The primary keys, foreign keys and fields are marked clearly in the picture and documentation. 
  

4. Schema Design

   1. In the folder of "Schema Design", we can see all content related to it, including the ER Diagram and diagram design logic and tradeoffs.
  
   2. The relational schema is built to support 4 core business workflows:
   
      1. App Dimension Management: Apps table stores statis app metadata. AppVersion table stores app version information that is linked to Apps table, with each record mapping a specific version to its parent app. These two tables are both linked to raw and processed review tables for version-based trend analysis.
      2. Scalable Quality Flagging: QualityFlags table records the catalog of all quality types, and new flag types can be added via simple insert statements without altering core review tables. QualityMapping table is a many-to-many junction table linking cleaned reviews table to their assigned quality flags, supporting multiple quality tags for every single review.
      3. Ingestion Tracking: IngestionRuns table acts as the single source of truth for every data collection job.
      4. Dual-Layer Review Storage: RawReviews table records immutable raw source layer, and ProcessedReviews is a more advanced and optimized layer. With these table, we can still trace back to the original reviews even we have made modifications on the reviews. 







