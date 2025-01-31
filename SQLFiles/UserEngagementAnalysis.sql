-- Marketing Analysis:
-- Loyal Users: Identifying the oldest users helps in recognizing long-term active users who might be valuable for loyalty programs.
select
  *
from
  users
order by
  created_at asc
limit
  5;

-- Inactive Users: Spotting users who haven't posted can guide targeted re-engagement strategies.
select
  users.id,
  users.username
from
  users
  left join photos on users.id = photos.user_id
group by
  users.id,
  users.username
having
  COUNT(photos.user_id) = 0;

-- Contest Winners: Finding the most liked photo helps in understanding user preferences and can drive future contests or promotions.
select
  users.id,
  users.username,
  photos.image_url,
  photos.id as photo_id,
  COUNT(likes.photo_id) as total_likes
from
  photos
  left join likes on photos.id = likes.photo_id
  left join users on photos.user_id = users.id
group by
  users.id,
  users.username,
  photos.id,
  photos.image_url
order by
  total_likes desc
limit
  1
offset
  0;

-- Hashtag Popularity: Knowing popular hashtags allows for better content strategy and increased visibility.
select
  tags.id as tag_id,
  tags.tag_name,
  COUNT(photo_tags.tag_id) as countOfTagUsed
from
  tags
  left join photo_tags on tags.id = photo_tags.tag_id
group by
  tags.id,
  tags.tag_name
order by
  countOfTagUsed desc
limit
  5;

-- Optimal Ad Days: Scheduling ads on the days with the highest registration activity maximizes impact.
select
  TO_CHAR(created_at, 'Day') as "DayOfTheWeek",
  COUNT(*) as "TotalNoOfRegisteredUser"
from
  users
group by
  "DayOfTheWeek"
order by
  "TotalNoOfRegisteredUser" desc
limit
  2;

-- Investor Metrics:
-- User Engagement Metrics: Analyzing average posts and the ratio of photos to users
provides insight into overall engagement and activity levels.
select
  COUNT(photos.id) * 1.0 / NULLIF(COUNT(distinct photos.user_id), 0) as "AverageOfPostPerUser"
from
  users
  left join photos on users.id = photos.user_id;

select
  COALESCE(
    (
      select
        COUNT(*) * 1.0
      from
        photos
    ) / NULLIF(
      (
        select
          COUNT(*)
        from
          users
      ),
      0
    ),
    0
  ) as "PostPerUser";

-- Bots Detection: Identifying users who like all photos can help in maintaining the integrity of the platform.
select
  likes.user_id,
  users.username,
  COUNT(*) as "TotalUserLikesPerPost"
from
  likes
  inner join users on likes.user_id = users.id
group by
  likes.user_id,
  users.username
having
  COUNT(*) = (
    select
      COUNT(*)
    from
      photos
  )
order by
  "TotalUserLikesPerPost" desc;
