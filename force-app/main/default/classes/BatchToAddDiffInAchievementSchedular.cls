public class BatchToAddDiffInAchievementSchedular implements Schedulable {
	public void execute(SchedulableContext sc)
    {
        BatchToAddDiffInAchievement b = new BatchToAddDiffInAchievement();
       
        database.executeBatch(b);
    }
}