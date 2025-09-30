import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  scenarios: {
    rps50_consolidado: {
      executor: 'constant-arrival-rate',
      rate: 50, // 50 req/s
      timeUnit: '1s',
      duration: '5m',
      preAllocatedVUs: 20,
      maxVUs: 200,
    },
  },
  thresholds: {
    http_req_failed: ['rate<=0.05'], // perda <= 5%
    http_req_duration: ['p(95)<=300', 'p(99)<=800'], // p95/p99 alvo
  },
};

const BASE = __ENV.BASE_URL || 'http://localhost:3000/api.fin/v1';
const MERCHANT = __ENV.MERCHANT_ID || 'b7b3c39e-1234-4f7c-8a55-1d2f3a4b5c6d';
const DATE = __ENV.DATE || '2025-09-30';

export default function () {
  const url = `${BASE}/consolidado?merchantId=${MERCHANT}&data=${DATE}`;
  const res = http.get(url);
  check(res, {
    'status is 200': (r) => r.status === 200,
    'has saldoFinal': (r) => r.json('saldoFinal') !== undefined,
  });
  sleep(0.01);
}
