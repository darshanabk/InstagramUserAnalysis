# Instagram User Engagement Analysis

## Project Overview
This project aims to analyze user engagement and activity on Instagram to provide insights into:
- Identifying the **oldest users** (loyal users)
- **Inactive users** who have never posted
- Determining **contest winners** based on the highest likes
- Finding **popular hashtags** for better engagement
- Discovering the **optimal days** to run ad campaigns
- Measuring **user engagement** with post frequency analysis
- Detecting **potential bots** that like every photo

## Tech Stack Used
- **SQL | Supabase**: Used for querying and visualizing the data.

---

## SQL Queries & Outputs

### **Marketing Analysis**

#### **1️ Loyal Users** - Identifying the oldest users
**Objective**: Recognize long-term active users for loyalty programs.
```sql
SELECT * 
FROM users 
ORDER BY created_at ASC 
LIMIT 5;
```
**Output**: Returns the five oldest users based on their account creation date.

---

#### **2️ Inactive Users** - Users who have never posted a photo  
**Objective**: Spot inactive users for targeted re-engagement strategies.
```sql
SELECT users.id, users.username 
FROM users 
LEFT JOIN photos ON users.id = photos.user_id 
GROUP BY users.id, users.username 
HAVING COUNT(photos.user_id) = 0;
```
**Output**: Identifies users who have never posted a photo.

---

#### **3️ Contest Winners** - Users with the most likes on a single photo  
**Objective**: Find the most liked photo to drive future contests or promotions.
```sql
SELECT users.id, users.username, photos.image_url, photos.id AS photo_id, 
       COUNT(likes.photo_id) AS total_likes 
FROM photos 
LEFT JOIN likes ON photos.id = likes.photo_id 
LEFT JOIN users ON photos.user_id = users.id 
GROUP BY users.id, users.username, photos.id, photos.image_url 
ORDER BY total_likes DESC 
LIMIT 1 OFFSET 0;
```
**Output**: Retrieves the user with the most liked photo, along with their details.

---

#### **4️ Hashtag Popularity** - Top 5 most used hashtags  
**Objective**: Help brands use the best-performing hashtags.
```sql
SELECT tags.id AS tag_id, tags.tag_name, COUNT(photo_tags.tag_id) AS countOfTagUsed 
FROM tags 
LEFT JOIN photo_tags ON tags.id = photo_tags.tag_id 
GROUP BY tags.id, tags.tag_name 
ORDER BY countOfTagUsed DESC 
LIMIT 5;
```
**Output**: Lists the top five most frequently used hashtags.

---

#### **5️ Optimal Ad Days** - Best days to launch ads  
**Objective**: Identify the days with the highest user registrations.
```sql
SELECT TO_CHAR(created_at, 'Day') AS "DayOfTheWeek", 
       COUNT(*) AS "TotalNoOfRegisteredUser" 
FROM users 
GROUP BY "DayOfTheWeek" 
ORDER BY "TotalNoOfRegisteredUser" DESC 
LIMIT 2;
```
**Output**: Determines the top two days with the most user registrations.

---

### **Investor Metrics**

#### **6️ User Engagement** - Average number of posts per user  
**Objective**: Measure how frequently users post on Instagram.
```sql
SELECT COUNT(photos.id) * 1.0 / NULLIF(COUNT(DISTINCT photos.user_id), 0) AS "AverageOfPostPerUser" 
FROM users 
LEFT JOIN photos ON users.id = photos.user_id;
```
**Output**: Calculates the average number of posts per user.

---

#### **7️ Post-to-User Ratio** - Total photos divided by users  
**Objective**: Assess overall posting trends on the platform.
```sql
SELECT COALESCE(
    (SELECT COUNT(*) * 1.0 FROM photos) / 
    NULLIF((SELECT COUNT(*) FROM users), 0), 
    0
) AS "PostPerUser";
```
📌 **Output**: Returns the ratio of total photos to total users.

---

#### **8️ Bot Detection** - Users who like every photo  
**Objective**: Detect fake or bot accounts.
```sql
SELECT likes.user_id, users.username, COUNT(*) AS "TotalUserLikesPerPost" 
FROM likes 
INNER JOIN users ON likes.user_id = users.id 
GROUP BY likes.user_id, users.username 
HAVING COUNT(*) = (SELECT COUNT(*) FROM photos) 
ORDER BY "TotalUserLikesPerPost" DESC;
```
**Output**: Identifies users who have liked every single photo, which may indicate bot activity.

---

## **Key Insights**
**Loyal Users**: Recognizing the oldest users helps in customer retention and loyalty programs.  
**Inactive Users**: Pinpointing users who haven't posted allows for re-engagement strategies.  
**Contest Winners**: Identifying the most liked photos helps in contest planning.  
**Hashtag Popularity**: Knowing popular hashtags allows brands to improve engagement.  
**Ad Campaign Optimization**: Scheduling ads on peak user registration days ensures maximum reach.  
**User Engagement**: Understanding how often users post provides insight into platform activity.  
**Bot Detection**: Filtering out suspicious activity helps maintain platform integrity.  

---

## **Conclusion**
This project provides valuable insights into Instagram user behavior and platform engagement. These findings help in shaping marketing strategies, optimizing ad placements, improving user retention, and ensuring authenticity by detecting potential bot activity.

**Next Steps:**
- Integrating **automated reports** for engagement tracking.
- Applying **machine learning** to detect more complex user behavior patterns.
- Expanding analysis to include **user demographics and geolocation trends**.

---
## 📂 **File Structure**
```
📦 InstagramUserAnalysis
 ┣ 📜 INSTAGRAM_ANALYSIS.md  # This document
 ┣ 📂 Source
 ┃ ┣ 📜 comments.csv
 ┃ ┣ 📜 follows.csv
 ┃ ┣ 📜 likes.csv
 ┃ ┣ 📜 photo_tags.csv
 ┃ ┣ 📜 photos.csv
 ┃ ┣ 📜 tags.csv
 ┃ ┗ 📜 users.csv
 ┣ 📂 SQLFiles
 ┃ ┗ 📜 UserEngagementAnalysis.sql
 ┗ 📂 Report
   ┗ 📜 Instagram_Engagement_Report.pdf
```

