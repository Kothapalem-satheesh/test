import { PieChart, Pie, Cell, ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip, Legend } from 'recharts';

const STATUS_COLORS = {
  Pass: '#22c55e',
  Partial: '#eab308',
  Fail: '#ef4444',
  'Not Applicable': '#9ca3af',
};

const RISK_COLORS = { High: '#ef4444', Medium: '#f59e0b', Low: '#3b82f6' };

export function ScoreGauge({ percentage }) {
  const color = percentage >= 80 ? '#22c55e' : percentage >= 60 ? '#eab308' : '#ef4444';
  const data = [
    { value: percentage },
    { value: 100 - percentage },
  ];

  return (
    <div className="relative">
      <ResponsiveContainer width="100%" height={200}>
        <PieChart>
          <Pie
            data={data}
            cx="50%"
            cy="50%"
            startAngle={180}
            endAngle={0}
            innerRadius={60}
            outerRadius={80}
            dataKey="value"
            stroke="none"
          >
            <Cell fill={color} />
            <Cell fill="#e5e7eb" />
          </Pie>
        </PieChart>
      </ResponsiveContainer>
      <div className="absolute inset-0 flex items-center justify-center" style={{ marginTop: '-20px' }}>
        <div className="text-center">
          <span className="text-3xl font-bold" style={{ color }}>{percentage}%</span>
          <p className="text-xs text-gray-500">Overall</p>
        </div>
      </div>
    </div>
  );
}

export function FrameworkBarChart({ frameworkScores }) {
  const data = Object.entries(frameworkScores || {}).map(([name, fw]) => ({
    name: name.replace('OWASP ', ''),
    score: fw.percentage,
    pass: fw.pass,
    partial: fw.partial,
    fail: fw.fail,
  }));

  if (!data.length) return <p className="text-gray-500 text-sm text-center py-8">No framework data</p>;

  return (
    <ResponsiveContainer width="100%" height={250}>
      <BarChart data={data} layout="vertical" margin={{ left: 20 }}>
        <XAxis type="number" domain={[0, 100]} />
        <YAxis type="category" dataKey="name" width={80} tick={{ fontSize: 12 }} />
        <Tooltip formatter={(val) => `${val}%`} />
        <Bar dataKey="score" fill="#3b82f6" radius={[0, 4, 4, 0]} />
      </BarChart>
    </ResponsiveContainer>
  );
}

export function RiskPieChart({ riskSummary }) {
  const data = Object.entries(riskSummary || {})
    .filter(([, count]) => count > 0)
    .map(([name, value]) => ({ name, value }));

  if (!data.length) return <p className="text-gray-500 text-sm text-center py-8">No risks identified</p>;

  return (
    <ResponsiveContainer width="100%" height={200}>
      <PieChart>
        <Pie data={data} cx="50%" cy="50%" outerRadius={70} dataKey="value" label={({ name, value }) => `${name}: ${value}`}>
          {data.map((entry) => (
            <Cell key={entry.name} fill={RISK_COLORS[entry.name] || '#9ca3af'} />
          ))}
        </Pie>
        <Legend />
      </PieChart>
    </ResponsiveContainer>
  );
}

export function StatusDistribution({ results }) {
  const counts = { Pass: 0, Partial: 0, Fail: 0, 'Not Applicable': 0 };
  (results || []).forEach((r) => { counts[r.status] = (counts[r.status] || 0) + 1; });

  const data = Object.entries(counts)
    .filter(([, v]) => v > 0)
    .map(([name, value]) => ({ name, value }));

  if (!data.length) return null;

  return (
    <ResponsiveContainer width="100%" height={200}>
      <PieChart>
        <Pie data={data} cx="50%" cy="50%" outerRadius={70} dataKey="value" label>
          {data.map((entry) => (
            <Cell key={entry.name} fill={STATUS_COLORS[entry.name]} />
          ))}
        </Pie>
        <Tooltip />
        <Legend />
      </PieChart>
    </ResponsiveContainer>
  );
}
