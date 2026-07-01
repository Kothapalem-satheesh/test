import { Link } from 'react-router-dom';



const STATUS_BADGE = {

  Pass: 'badge-pass',

  Partial: 'badge-partial',

  Fail: 'badge-fail',

  'Not Applicable': 'badge-na',

};



function evidencePreview(evidence) {

  if (!evidence?.length) return null;

  const first = evidence[0];

  const doc = first.source_document || 'Document';

  const snippet = (first.text || '').slice(0, 80);

  const more = evidence.length > 1 ? ` +${evidence.length - 1} more` : '';

  return { doc, snippet, more };

}



export default function ResultsTable({ results, filters, onFilterChange }) {

  return (

    <div>

      <div className="flex flex-wrap gap-2 mb-4">

        <select

          className="input w-auto text-sm"

          value={filters.status || ''}

          onChange={(e) => onFilterChange({ ...filters, status: e.target.value })}

        >

          <option value="">All Statuses</option>

          <option value="Pass">Pass</option>

          <option value="Partial">Partial</option>

          <option value="Fail">Fail</option>

          <option value="Not Applicable">Not Applicable</option>

        </select>

        <select

          className="input w-auto text-sm"

          value={filters.framework || ''}

          onChange={(e) => onFilterChange({ ...filters, framework: e.target.value })}

        >

          <option value="">All Frameworks</option>

          {[...new Set(results.map((r) => r.requirement?.framework?.name).filter(Boolean))].map((fw) => (

            <option key={fw} value={fw}>{fw}</option>

          ))}

        </select>

        <select

          className="input w-auto text-sm"

          value={filters.severity || ''}

          onChange={(e) => onFilterChange({ ...filters, severity: e.target.value })}

        >

          <option value="">All Severities</option>

          <option value="Critical">Critical</option>

          <option value="High">High</option>

          <option value="Medium">Medium</option>

          <option value="Low">Low</option>

        </select>

        <select

          className="input w-auto text-sm"

          value={filters.sort || 'requirement_code'}

          onChange={(e) => onFilterChange({ ...filters, sort: e.target.value })}

        >

          <option value="requirement_code">Sort by Code</option>

          <option value="status">Sort by Status</option>

          <option value="severity">Sort by Severity</option>

        </select>

      </div>



      <div className="overflow-x-auto">

        <table className="w-full text-sm">

          <thead>

            <tr className="border-b border-gray-200 text-left">

              <th className="py-3 px-2 font-medium text-gray-600">Code</th>

              <th className="py-3 px-2 font-medium text-gray-600">Framework</th>

              <th className="py-3 px-2 font-medium text-gray-600">Requirement</th>

              <th className="py-3 px-2 font-medium text-gray-600">Status</th>

              <th className="py-3 px-2 font-medium text-gray-600">Evidence</th>

              <th className="py-3 px-2 font-medium text-gray-600">Confidence</th>

              <th className="py-3 px-2 font-medium text-gray-600">Risk</th>

            </tr>

          </thead>

          <tbody>

            {results.length === 0 ? (

              <tr>

                <td colSpan={7} className="py-8 text-center text-gray-500">

                  No results match your filters

                </td>

              </tr>

            ) : (

              results.map((result) => {

                const ev = evidencePreview(result.evidence);

                return (

                  <tr key={result.id} className="border-b border-gray-100 hover:bg-gray-50">

                    <td className="py-3 px-2">

                      <Link to={`/results/${result.id}`} className="text-primary-600 hover:underline font-mono text-xs">

                        {result.requirement?.requirement_code}

                      </Link>

                    </td>

                    <td className="py-3 px-2 text-gray-600 text-xs">

                      {result.requirement?.framework?.name?.replace('OWASP ', '')}

                    </td>

                    <td className="py-3 px-2 max-w-xs truncate" title={result.requirement?.requirement_text}>

                      {result.requirement?.requirement_text}

                    </td>

                    <td className="py-3 px-2">

                      <span className={STATUS_BADGE[result.status] || 'badge-na'}>{result.status}</span>

                    </td>

                    <td className="py-3 px-2 max-w-[200px]">

                      {ev ? (

                        <Link to={`/results/${result.id}`} className="block text-xs text-gray-600 hover:text-primary-600">

                          <span className="font-medium text-gray-700">{ev.doc}</span>

                          <span className="block truncate italic">&quot;{ev.snippet}...&quot;{ev.more}</span>

                        </Link>

                      ) : (

                        <span className="text-xs text-gray-400">No matching text found</span>

                      )}

                    </td>

                    <td className="py-3 px-2 text-gray-600">{result.confidence}%</td>

                    <td className="py-3 px-2">

                      {result.risk_level && (

                        <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${

                          result.risk_level === 'High' ? 'bg-red-100 text-red-700' :

                          result.risk_level === 'Medium' ? 'bg-yellow-100 text-yellow-700' :

                          'bg-blue-100 text-blue-700'

                        }`}>{result.risk_level}</span>

                      )}

                    </td>

                  </tr>

                );

              })

            )}

          </tbody>

        </table>

      </div>

    </div>

  );

}

