import http from 'k6/http';

export const options = {
  scenarios: {
    contacts: {
      executor: 'ramping-arrival-rate',
      startRate: 10,
      timeUnit: '1s',
      preAllocatedVUs: 2,
      maxVUs: 50,
      stages: [
        { target: 70, duration: '20s' },
        { target: 30, duration: '10s' },
      ],
    },
  },
};

export default function () {
  const req = http.get('https://test.k6.io/contacts.php');
}
