namespace AppDemo.Models
{
    public class ConfidenceRule
    {
        public int Id { get; }
        public string Name { get; }

        public string Text { get; }
        public string Rule { get; }

        public ConfidenceRule(int id, string name, string text, string rule)
        {
            Id = id;
            Name = name;

            Text = text;
            Rule = rule;
        }
    }
}