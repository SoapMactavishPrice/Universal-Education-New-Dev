public class BatchToCalculateAchievementSchedular implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        BatchToCalculateAchievement b = new BatchToCalculateAchievement();
       
        database.executeBatch(b);
    }
}