// Loan Calculator with Multiple Interest Rates
class LoanCalculator {
  constructor() {
    this.interestRates = [];
    this.segmentCount = 1;
    this.init();
  }

  init() {
    this.setupEventListeners();
    this.updateInterestRates();
  }

  setupEventListeners() {
    const addButton = document.getElementById('add-interest-rate');
    const simulateButton = document.getElementById('simulate');

    if (!addButton || !simulateButton) {
      console.error('Loan Calculator: Required elements not found');
      return;
    }

    addButton.addEventListener('click', () => this.addInterestRateSegment());
    simulateButton.addEventListener('click', () => {
      try {
        this.simulate();
      } catch (error) {
        console.error('Loan Calculator simulation error:', error);
        alert('An error occurred during simulation. Please check the console for details.');
      }
    });

    // Use event delegation for delete buttons
    document.addEventListener('click', (e) => {
      if (e.target.classList.contains('delete-segment')) {
        this.deleteSegment(e.target);
      }
    });
  }

  addInterestRateSegment() {
    // Find the highest existing segment number to ensure unique IDs
    const existingRateInputs = document.querySelectorAll('input[id^="rate-"]');
    let maxSegmentNumber = 0;
    existingRateInputs.forEach(input => {
      const match = input.id.match(/rate-(\d+)/);
      if (match) {
        const num = parseInt(match[1], 10);
        if (num > maxSegmentNumber) {
          maxSegmentNumber = num;
        }
      }
    });

    this.segmentCount = maxSegmentNumber + 1;
    const tables = document.querySelectorAll('table');
    const table = tables[1] || tables[tables.length - 1];

    if (!table) {
      console.error('Loan Calculator: Interest rate table not found');
      return;
    }

    const rateRow = document.createElement('tr');
    rateRow.innerHTML = `
            <td><label for="rate-${this.segmentCount}">Interest Rate (%)</label></td>
            <td><input type="number" id="rate-${this.segmentCount}" value="5" /></td>
        `;

    const durationRow = document.createElement('tr');
    durationRow.innerHTML = `
            <td><label for="duration-${this.segmentCount}">Duration (Years)</label></td>
            <td><input type="number" id="duration-${this.segmentCount}" value="1" /></td>
            <td><button type="button" class="delete-segment">🗑️</button></td>
        `;

    table.appendChild(rateRow);
    table.appendChild(durationRow);
  }

  deleteSegment(button) {
    // Only allow deletion if there's more than one segment
    const currentSegments = document.querySelectorAll('input[id^="rate-"]').length;
    if (currentSegments <= 1) {
      alert('You must have at least one interest rate segment.');
      return;
    }

    const durationRow = button.closest('tr');
    const prevRow = durationRow.previousElementSibling;

    // Remove both rate and duration rows for this segment
    // The rate row should be the previous sibling of the duration row
    if (prevRow && prevRow.querySelector('input[id^="rate-"]')) {
      prevRow.remove();
    }
    durationRow.remove();

    this.renumberSegments();
  }

  renumberSegments() {
    const rateInputs = document.querySelectorAll('input[id^="rate-"]');
    const durationInputs = document.querySelectorAll('input[id^="duration-"]');

    rateInputs.forEach((input, index) => {
      const newId = `rate-${index + 1}`;
      input.id = newId;
      input.previousElementSibling.setAttribute('for', newId);
    });

    durationInputs.forEach((input, index) => {
      const newId = `duration-${index + 1}`;
      input.id = newId;
      input.previousElementSibling.setAttribute('for', newId);
    });

    this.segmentCount = rateInputs.length;
  }

  updateInterestRates() {
    this.interestRates = [];
    const rateInputs = document.querySelectorAll('input[id^="rate-"]');
    rateInputs.forEach((rateInput) => {
      const rateId = rateInput.id;
      const segmentNumber = rateId.replace('rate-', '');
      const durationInput = document.getElementById(`duration-${segmentNumber}`);

      if (durationInput) {
        const rate = parseFloat(rateInput.value) || 0;
        const duration = parseFloat(durationInput.value) || 0;
        this.interestRates.push({
          rate: rate / 100, // Convert to decimal
          duration: duration,
          months: duration * 12
        });
      }
    });
  }

  formatCurrency(amount) {
    return new Intl.NumberFormat('id-ID', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }).format(amount);
  }

  simulate() {
    this.updateInterestRates();

    const loanAmountInput = document.getElementById('loan-amount');
    const loanDurationInput = document.getElementById('loan-duration');

    if (!loanAmountInput || !loanDurationInput) {
      alert('Loan calculator elements not found. Please refresh the page.');
      return;
    }

    const loanAmount = this.parseCurrency(loanAmountInput.value);
    const loanDurationYears = parseFloat(loanDurationInput.value) || 0;
    const totalMonths = loanDurationYears * 12;

    // Debug: Log segments
    console.log('Loan Calculator: Processing segments:', this.interestRates.length);
    this.interestRates.forEach((seg, idx) => {
      console.log(`Segment ${idx + 1}: Rate=${(seg.rate * 100).toFixed(2)}%, Duration=${seg.duration} years, Months=${seg.months}`);
    });

    // Validate that sum of interest rate segment durations equals loan duration
    const totalSegmentDuration = this.interestRates.reduce((sum, segment) => sum + segment.duration, 0);
    if (Math.abs(totalSegmentDuration - loanDurationYears) > 0.01) {
      alert(`The total duration of all interest rate segments (${totalSegmentDuration.toFixed(2)} years) must exactly match the loan duration (${loanDurationYears} years).`);
      return;
    }

    if (loanAmount <= 0 || totalMonths <= 0 || this.interestRates.length === 0) {
      alert('Please enter valid loan amount, duration, and interest rates.');
      return;
    }

    // Calculate amortization schedule
    const schedule = this.calculateAmortizationSchedule(loanAmount, totalMonths);
    console.log('Loan Calculator: Schedule calculated with', schedule.length, 'months');

    if (schedule.length === 0) {
      alert('No schedule could be calculated. Please check your inputs.');
      return;
    }

    // Update summary
    this.updateSummary(schedule);

    // Update results table
    this.updateResultsTable(schedule);
  }

  parseCurrency(numberString) {
    // Remove commas and spaces, then parse
    return parseFloat(numberString.replace(/,|\s/g, '')) || 0;
  }

  calculateAmortizationSchedule(principal, totalMonths) {
    const schedule = [];
    let remainingPrincipal = principal;
    let totalPaidPrincipal = 0;
    let totalPaidInterest = 0;
    let currentMonth = 0;

    // Process each interest rate segment
    for (let segmentIndex = 0; segmentIndex < this.interestRates.length; segmentIndex++) {
      const segment = this.interestRates[segmentIndex];
      const segmentMonths = Math.min(segment.months, totalMonths - currentMonth);

      console.log(`Processing segment ${segmentIndex + 1}: Rate=${(segment.rate * 100).toFixed(2)}%, SegmentMonths=${segmentMonths}, RemainingPrincipal=${remainingPrincipal.toFixed(2)}, CurrentMonth=${currentMonth}`);

      if (segmentMonths <= 0) {
        console.log(`Skipping segment ${segmentIndex + 1}: segmentMonths is 0`);
        break;
      }

      // Calculate remaining months across all remaining segments (including current segment)
      const remainingMonths = totalMonths - currentMonth;

      // Calculate monthly payment for this segment
      // For the payment calculation, we need to pay off the remaining principal over all remaining months
      // However, we'll use the current segment's rate, and recalculate when we move to the next segment
      const monthlyRate = segment.rate / 12;

      // Calculate payment to amortize remaining principal over remaining months at current rate
      // This ensures the loan is paid off by the end of all segments
      const monthlyPayment = this.calculateMonthlyPayment(remainingPrincipal, monthlyRate, remainingMonths);

      // Process each month in this segment
      for (let monthInSegment = 1; monthInSegment <= segmentMonths && currentMonth < totalMonths; monthInSegment++) {
        currentMonth++;
        const monthlyInterest = remainingPrincipal * monthlyRate;
        const monthlyPrincipal = monthlyPayment - monthlyInterest;

        // Ensure we don't overpay principal
        const actualPrincipalPayment = Math.min(monthlyPrincipal, remainingPrincipal);
        // If we're paying off the loan, the actual payment might be less than monthlyPayment
        const actualPayment = actualPrincipalPayment + monthlyInterest;
        const actualInterestPayment = monthlyInterest;

        remainingPrincipal -= actualPrincipalPayment;
        totalPaidPrincipal += actualPrincipalPayment;
        totalPaidInterest += actualInterestPayment;

        schedule.push({
          month: currentMonth,
          remainingPrincipal: remainingPrincipal,
          paidPrincipal: actualPrincipalPayment,
          paidInterest: actualInterestPayment,
          monthlyPayment: actualPayment,
          totalPaidPrincipal: totalPaidPrincipal,
          totalPaidInterest: totalPaidInterest
        });

        // Break if loan is paid off
        if (remainingPrincipal <= 0.01) break;
      }

      // Break if loan is paid off before processing next segment
      if (remainingPrincipal <= 0.01) break;
    }

    return schedule;
  }

  calculateMonthlyPayment(principal, monthlyRate, months) {
    if (monthlyRate === 0) {
      return principal / months;
    }

    const numerator = principal * monthlyRate * Math.pow(1 + monthlyRate, months);
    const denominator = Math.pow(1 + monthlyRate, months) - 1;
    return numerator / denominator;
  }

  updateSummary(schedule) {
    if (schedule.length === 0) return;

    const lastEntry = schedule[schedule.length - 1];
    const loanAmount = this.parseCurrency(document.getElementById('loan-amount').value);

    const summaryDiv = document.querySelector('#summary-result');
    if (!summaryDiv) {
      console.error('Loan Calculator: Summary result container not found');
      return;
    }

    summaryDiv.innerHTML = `
            <div><strong>Principal:</strong> ${this.formatCurrency(loanAmount)}</div>
            <div><strong>Total Interest:</strong> ${this.formatCurrency(lastEntry.totalPaidInterest)}</div>
            <div><strong>Total Payment:</strong> ${this.formatCurrency(lastEntry.totalPaidPrincipal + lastEntry.totalPaidInterest)}</div>
            <div><strong>Total Interest (%):</strong> ${(lastEntry.totalPaidInterest / loanAmount * 100).toFixed(1)}%</div>
        `;
  }

  updateResultsTable(schedule) {
    const resultsDiv = document.querySelector('#table-result');
    if (!resultsDiv) {
      console.error('Loan Calculator: Table result container not found');
      return;
    }

    resultsDiv.innerHTML = '';
    this.addAmortizationTable(schedule);
  }

  addAmortizationTable(schedule) {
    const resultsDiv = document.querySelector('#table-result');
    if (!resultsDiv) {
      console.error('Loan Calculator: Table result container not found');
      return;
    }

    // Create new amortization table
    const amortizationTable = document.createElement('table');
    amortizationTable.id = 'amortization-table';
    amortizationTable.innerHTML = `
            <thead>
                <tr>
                    <th>N-Month</th>
                    <th>Remaining Principal</th>
                    <th>Paid Principal</th>
                    <th>Paid Interest</th>
                    <th>Monthly Payment</th>
                </tr>
            </thead>
            <tbody>
                ${schedule.map(entry => `
                    <tr>
                        <td>${entry.month}</td>
                        <td>${this.formatCurrency(entry.remainingPrincipal)}</td>
                        <td>${this.formatCurrency(entry.paidPrincipal)}</td>
                        <td>${this.formatCurrency(entry.paidInterest)}</td>
                        <td>${this.formatCurrency(entry.monthlyPayment)}</td>
                    </tr>
                `).join('')}
            </tbody>
        `;

    // Insert into the results container
    resultsDiv.appendChild(amortizationTable);
  }
}

// Initialize the calculator when DOM is loaded
function initLoanCalculator() {
  // Prevent multiple initializations
  if (window.loanCalculatorInstance) {
    return;
  }
  window.loanCalculatorInstance = new LoanCalculator();
}

// Check if DOM is already loaded
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initLoanCalculator);
} else {
  // DOM is already loaded
  initLoanCalculator();
}