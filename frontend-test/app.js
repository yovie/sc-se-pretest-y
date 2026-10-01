function Cell(row, col) {
  this.row = row;
  this.col = col;
  this.isDark = (row + col) % 2 === 0;
  this.element = null;
}

Cell.prototype.render = function () {
  const div = document.createElement('div');
  div.classList.add('cell', this.isDark ? 'cell-dark' : 'cell-light');
  this.element = div;
  return div;
};

function Board(rows, cols) {
  this.rows = rows;
  this.cols = cols;
  this.cells = [];
  this.element = null;
  this.K = { baris: 1, kolom: 1 };
}

Board.prototype.generate = function () {
  this.cells = [];
  for (let r = 1; r <= this.rows; r++) {
    const rowCells = [];
    for (let c = 1; c <= this.cols; c++) {
      rowCells.push(new Cell(r, c));
    }
    this.cells.push(rowCells);
  }
};

Board.prototype.render = function (container) {
  const board = document.createElement('div');
  board.classList.add('board');
  board.style.gridTemplateColumns = `repeat(${this.cols}, 1fr)`;

  for (const rowCells of this.cells) {
    for (const cell of rowCells) {
      board.appendChild(cell.render());
      cell.element.addEventListener('mouseenter', () => this.hoverCell(cell, true));
      cell.element.addEventListener('mouseleave', () => this.hoverCell(cell, false));
      cell.element.addEventListener('click', () => this.moveTo(cell));
    }
  }

  container.appendChild(board);
  this.element = board;
  this.drawK();
};

Board.prototype.clearK = function () {
  if (!this.element) {
    return;
  }
  const mark = this.element.querySelector('.k-mark');
  if (mark) {
    mark.remove();
  }
};

Board.prototype.drawK = function () {
  this.clearK();
  const row = this.cells[this.K.baris - 1];
  const cell = row && row[this.K.kolom - 1];
  if (!cell || !cell.element) {
    return;
  }
  const span = document.createElement('span');
  span.classList.add('k-mark');
  span.textContent = 'K';
  cell.element.appendChild(span);
};

Board.prototype.canMove = function (cell) {
  return (
    (Math.abs(this.K.kolom - cell.col) === 2 &&
    Math.abs(this.K.baris - cell.row) === 1) ||
    (Math.abs(this.K.kolom - cell.col) === 1 &&
    Math.abs(this.K.baris - cell.row) === 2)
  );
};

Board.prototype.moveTo = function (cell) {
  if (!this.canMove(cell)) {
    return;
  }
  this.K.baris = cell.row;
  this.K.kolom = cell.col;
  this.drawK();
};

Board.prototype.hoverCell = function (cell, entering) {
  if (!entering) {
    cell.element.classList.remove('can-move', 'cant-move');
    return;
  }
  cell.element.classList.toggle('can-move', this.canMove(cell));
  cell.element.classList.toggle('cant-move', !this.canMove(cell));
};

Board.prototype.destroy = function () {
  if (this.element && this.element.parentNode) {
    this.element.parentNode.removeChild(this.element);
  }
  this.element = null;
  this.cells = [];
};

const container = document.getElementById('board-container');
const containerParent = container.parentElement;
const rowInput = document.getElementById('row');
const colInput = document.getElementById('column');
const generateBtn = document.getElementById('generate-btn');

let board = null;

function updateLayout(cols) {
  container.style.width = '';
  containerParent.classList.remove('container--full');

  let viewport = document.documentElement.clientWidth;
  let onePercent = viewport * 0.01;
  const defaultWidth = container.getBoundingClientRect().width;

  if (defaultWidth / cols < onePercent) {
    containerParent.classList.add('container--full');
    container.style.width = Math.min(cols * onePercent, viewport) + 'px';

    const after = document.documentElement.clientWidth;
    if (after < viewport) {
      viewport = after;
      onePercent = viewport * 0.01;
      container.style.width = Math.min(cols * onePercent, viewport) + 'px';
    }
  }

  const finalWidth = container.getBoundingClientRect().width;
  container.style.setProperty('--cell-size', finalWidth / cols + 'px');
}

generateBtn.addEventListener('click', function () {
  const rows = parseInt(rowInput.value, 10);
  const cols = parseInt(colInput.value, 10);

  if (Number.isNaN(rows) || Number.isNaN(cols)) {
    return;
  }

  if (board) {
    board.destroy();
    board = null;
  }

  board = new Board(rows, cols);
  board.generate();
  board.render(container);
  updateLayout(board.cols);
});

window.addEventListener('resize', function () {
  if (board) {
    updateLayout(board.cols);
  }
});
