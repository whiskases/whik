using System;
using System.Collections.Generic;

namespace Ryadel.Components.Diagnostics
{
    /// <summary>
    /// A small object to measure the time between two or more operations.
    /// </summary>
    public class TimeTracker
    {
        #region Nested Types
        // Определение перечисления для форматов времени
        public enum TimeFormat { Nanoseconds, Microseconds, Milliseconds, Seconds, Minutes, Hours }
        #endregion Nested Types

        #region Private Fields
        // Словарь для хранения временных меток каждой лапы
        private Dictionary<string, long> m_TrackList;
        #endregion Private Fields

        #region Constructor
        // Конструкторы класса
        public TimeTracker() : this(null)
        {
        }

        public TimeTracker(string lapName)
        {
            // Инициализация словаря, если он не был инициализирован ранее
            if (TrackList == null) m_TrackList = new Dictionary<string, long>();
            // Добавление начальной лапы, если указано имя
            if (!string.IsNullOrEmpty(lapName)) AddLap(lapName);
        }
        #endregion Constructor

        #region Methods
        /// <summary>
        /// Adds a lap to the TimeTracker
        /// </summary>
        /// <param name="lapName"></param>
        public void AddLap(string lapName)
        {
            // Добавление лапы в словарь с текущим временем
            TrackList[lapName] = GetCurrentTime();
        }

        /// <summary>
        /// </summary>
        /// <param name="startLap">name of the starting lap</param>
        /// <param name="endLap">name of the ending lap</param>
        /// <param name="format">a valid [TimeTracker.TimeFormat] enum value</param>
        /// <returns>a decimal representing the TimeDiff in time units specified by the given [TimeTracker.TimeFormat].</returns>
        public decimal GetLapTimeDiff(string startLap, string endLap, TimeFormat format = TimeFormat.Milliseconds)
        {
            // Проверка наличия начальной и конечной лапы в словаре
            if (!TrackList.ContainsKey(startLap)) throw new Exception(String.Format("Starting Lap '{0}' cannot be found.", startLap));
            if (!TrackList.ContainsKey(endLap)) throw new Exception(String.Format("Ending Lap '{0}' cannot be found.", endLap));
            // Вычисление временной разницы между лапами и возвращение в указанном формате
            return CalculateTime(TrackList[endLap] - TrackList[startLap], format);
        }

        protected virtual decimal CalculateTime(long tDiff, TimeFormat format = TimeFormat.Milliseconds)
        {
            // Вычисление временной разницы в указанном формате
            switch (format)
            {
                case TimeFormat.Nanoseconds:
                    return (decimal)(tDiff * 100);
                case TimeFormat.Microseconds:
                    return (decimal)(tDiff / (long)10);
                case TimeFormat.Milliseconds:
                default:
                    return (decimal)(tDiff / (long)10000);
                case TimeFormat.Seconds:
                    return (decimal)(tDiff / (long)10000000);
                case TimeFormat.Minutes:
                    return (decimal)(tDiff / (long)600000000);
                case TimeFormat.Hours:
                    return (decimal)(tDiff / (long)36000000000);
            }
        }

        /// <summary>
        /// </summary>
        /// <returns></returns>
        protected virtual long GetCurrentTime()
        {
            // Получение текущего времени в формате long
            return DateTime.UtcNow.ToFileTimeUtc();
        }

        /// <summary>
        /// </summary>
        /// <param name="lapNames"></param>
        protected void CheckLapNames(params string[] lapNames)
        {
            // Проверка наличия указанных лап в словаре
            foreach (string n in lapNames) if (!TrackList.ContainsKey(n)) throw new Exception(String.Format("Lap '{0}' cannot be found.", n));
        }
        #endregion Methods

        #region Properties
        /// <summary>
        /// </summary>
        public bool IsEmpty
        {
            // Свойство, возвращающее true, если словарь пуст, иначе false
            get { return (TrackList == null || TrackList.Count == 0); }
        }

        /// <summary>
        /// </summary>
        protected Dictionary<string, long> TrackList
        {
            // Защищенное свойство, возвращающее словарь лап
            get { return m_TrackList; }
        }
        #endregion Properties
    }
}
