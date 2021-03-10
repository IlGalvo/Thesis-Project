using System;

namespace AppDemo.Models
{
    public class ConfidenceRule : IEquatable<ConfidenceRule>
    {
        public int Id { get; }
        public string Name { get; }

        public string Text { get; }
        public string Rule { get; }

        public ConfidenceRule(int id, string name, string text, string rule)
        {
            Id = id;
            Name = name;

            Text = text.Trim();
            Rule = rule.Trim();
        }

        #region BASE_METHODS
        public override string ToString()
        {
            return ("Id: " + Id +
                "\nName: " + Name +
                "\nText: " + Text +
                "\nRule: " + Rule);
        }

        public override int GetHashCode()
        {
            var hashCode = Id.GetHashCode();

            hashCode += ((Name != null) ? Name.GetHashCode() : 0);
            hashCode += ((Text != null) ? Text.GetHashCode() : 0);
            hashCode += ((Rule != null) ? Rule.GetHashCode() : 0);

            return hashCode;
        }

        public override bool Equals(object obj)
        {
            return Equals(obj as ConfidenceRule);
        }

        public bool Equals(ConfidenceRule other)
        {
            if (other is null)
            {
                return false;
            }

            if (ReferenceEquals(this, other))
            {
                return true;
            }

            if (!(other is ConfidenceRule))
            {
                return false;
            }

            return (GetHashCode() == other.GetHashCode());
        }

        public static bool operator ==(ConfidenceRule left, ConfidenceRule right)
        {
            if (left is null)
            {
                if (right is null)
                {
                    return true;
                }

                return false;
            }

            return left.Equals(right);
        }

        public static bool operator !=(ConfidenceRule left, ConfidenceRule right)
        {
            return (!(left == right));
        }
        #endregion
    }
}