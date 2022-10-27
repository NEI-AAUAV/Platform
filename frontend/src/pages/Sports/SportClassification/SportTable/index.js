import React from "react";
// import PerfectScrollbar from "perfect-scrollbar";
// import { Component } from "@angular/core";
import { Table } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faAngleUp,
  faAngleDown,
  faAngleDoubleDown,
} from "@fortawesome/free-solid-svg-icons";
import "./index.css";

// const Ps = new PerfectScrollbar();

// class SportTable extends React.Component {
//   constructor(props) {
//     super(props)
    
//     this.state = {
//       items: props.items,
//       sortingProp: 'position',
//       sortingDirectionAsc: true
//     }
    
//     this.scrollSidebar = this.scrollSidebar.bind(this)
//     this.scrollBodyListHeader = this.scrollBodyListHeader.bind(this)
//   }
  
//   componentDidMount() {
//     var $fixedTableBodyList = React.findDOMNode(this.refs.fixedTableBodyList)
    
//     Ps.initialize($fixedTableBodyList)
    
//     $fixedTableBodyList.addEventListener('ps-scroll-y', this.scrollSidebar)
//     $fixedTableBodyList.addEventListener('ps-y-reach-start', () => this.scrollSidebar({target: { scrollTop: 0 }}))
//     $fixedTableBodyList.addEventListener('ps-scroll-x', this.scrollBodyListHeader)
//     $fixedTableBodyList.addEventListener('ps-x-reach-start', () => this.scrollBodyListHeader({target: { scrollLeft: 0 }}))
//   }
  
//   componentWillReceiveProps(nextProps) {
//     this.setState({
//       items: nextProps.items,
//       sortingProp: 'id',
//       sortingDirectionAsc: true
//     })
//   }
  
//   scrollSidebar(event) {    
//     React.findDOMNode(this.refs.sidebarList).style.top = `${-event.target.scrollTop}px`   
//   }
  
//   scrollBodyListHeader(event) {    
//     React.findDOMNode(this.refs.bodyListHeader).style.left = `${-event.target.scrollLeft}px`
//   }
  
//   sortAsc(prop) {
//     return this.state.items.sort((a, b) => {
//       if (a[prop] > b[prop]) {
//         return 1;
//       }

//       if (a[prop] < b[prop]) {
//         return -1;
//       }

//       return 0;
//     })
//   }
  
//   sortDesc(prop) {
//     return this.state.items.sort((a, b) => {
//       if (a[prop] < b[prop]) {
//         return 1;
//       }

//       if (a[prop] > b[prop]) {
//         return -1;
//       }

//       return 0;
//     })
//   }
  
//   sortBy(prop) {
//     if (prop === this.state.sortingProp) {
//       if (this.state.sortingDirectionAsc) {
//         this.setState({
//           sortingDirectionAsc: false,
//           items: this.sortDesc(prop)
//         })
//         return
//       } else {
//         this.setState({
//           sortingDirectionAsc: true,
//           items: this.sortAsc(prop)
//         })
//         return
//       }
//     }
//     this.setState({
//       sortingProp: prop,
//       sortingDirectionAsc: true,
//       items: this.sortAsc(prop)
//     })
//   }
//   enderFixedList() {
//     var items = this.state.items.map((i) => {
//       return (
//         <div className="fixed-table__row">
//           <div className="fixed-table__col">{i.position}</div>
//         </div>
//       )
//     })
    
//     return (
//       <div ref="sidebarList"
//            className="fixed-table__list fixed-table__list--fixed">
//         {items}
//       </div>
//     )
//   }
  
//   renderList() {
//     var items = this.state.items.map((i, index) => {
//       return (
//         <div key={`details-row-${index}`}
//              className="fixed-table__row">
//           <div className="fixed-table__col">{i.position}</div>
//           <div className="fixed-table__col">{i.team}</div>
//           <div className="fixed-table__col">{i.games}</div>
//           <div className="fixed-table__col">{i.points}</div>
//           <div className="fixed-table__col">{i.victories}</div>
//           <div className="fixed-table__col">{i.draws}</div>
//           <div className="fixed-table__col">{i.defeats}</div>
//           <div className="fixed-table__col">{i.scored_goals}</div>
//           <div className="fixed-table__col">{i.souffered_goals}</div>
//           <div className="fixed-table__col">{i.division_group}</div>
//           <div className="fixed-table__col">{i.last_games}</div>
//         </div>
//       )
//     })
//     return (
//       <div ref="fixedTableBodyList"
//            onScroll="onBodyListScroll"
//            className="fixed-table__list">
//         {items}
//       </div>
//     )
//   }

//   render() {
//     return (
//       <div className="fixed-table">
//         <div className="fixed-table__sidebar">
//           <div className="fixed-table__header">
//             <div className="fixed-table__th"
//                  onClick={this.sortBy.bind(this, 'pos')}>Position</div>
//           </div>
//           <div className="fixed-table__scrollable-sidebar">
//             {this.renderFixedList()}
//           </div>
//         </div>
//         <div className="fixed-table__body">
//           <div className="fixed-table__header">
//             <div ref="bodyListHeader"
//                  className="fixed-table__scrollable-header">
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'position')}>Equipa</div>
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'games')}>Jogos</div>
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'points')}>Pontos</div>
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'victories')}>Vitórias</div>
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'draws')}>Empates</div>
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'defeats')}>Derrotas</div>
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'score_goals')}>Golos Marcados</div>
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'souffered_goals')}>Golos Sofridos</div>
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'divison_group')}>Divisão</div>
//               <div className="fixed-table__th"
//                    onClick={this.sortBy.bind(this, 'last_games')}>Últimos 5 Jogos</div>          
//             </div>
//           </div>
//           {this.renderList()}
//         </div>
//       </div>
//     )
//   }
// }

// SportTable.propTypes = {
//   items: React.PropTypes.array.isRequired
// }

// var items = [
//   {
//     "position": 1,
//     "team": "test1",
//     "games": "test2",
//     "points": "test3",
//     "victories": "test4",
//     "draws": "test5",
//     "defeats": "test6",
//     "scored_goals": "test7",
//     "souffered_goals": "test8",
//     "divison_group": "test9",
//     "last games": "test10"
//   }, {
//     "position": 2,
//     "team": "test11",
//     "games": "test12",
//     "points": "test13",
//     "victories": "test14",
//     "draws": "test15",
//     "defeats": "test16",
//     "scored_goals": "test17",
//     "souffered_goals": "test18",
//     "divison_group": "test19",
//     "last games": "test20"
//   }, {
//     "position": 3,
//     "team": "test21",
//     "games": "test22",
//     "points": "test23",
//     "victories": "test24",
//     "draws": "test25",
//     "defeats": "test26",
//     "scored_goals": "test27",
//     "souffered_goals": "test28",
//     "divison_group": "test29",
//     "last games": "test30"
//   }, {
//     "position": 4,
//     "team": "test31",
//     "games": "test32",
//     "points": "test33",
//     "victories": "test34",
//     "draws": "test35",
//     "defeats": "test36",
//     "scored_goals": "test37",
//     "souffered_goals": "test38",
//     "divison_group": "test39",
//     "last games": "test40"
//   }, {
//     "position": 5,
//     "team": "test41",
//     "games": "test42",
//     "points": "test43",
//     "victories": "test44",
//     "draws": "test45",
//     "defeats": "test46",
//     "scored_goals": "test47",
//     "souffered_goals": "test48",
//     "divison_group": "test49",
//     "last games": "test50"
//   }
// ]

// React.render( 
//   <SportTable items={items} /> ,
//   document.querySelector('.container')
// )


// var clone = document.getElementsByClassName("main-table")[0].cloneNode(true);
 
// clone.classList.add("clone");
// document.getElementById("table-scroll").append(clone);
// // https://codepen.io/paulobrien/pen/gWoVzN - scrollable table

const SportTable = (props) => {
  const UpArrow = <FontAwesomeIcon icon={faAngleUp} className="up" />;
  const DownArrow = <FontAwesomeIcon icon={faAngleDown} className="down" />;
  const DoubleDownArrow = (
    <FontAwesomeIcon icon={faAngleDoubleDown} className="down" />
  );

  const header = [["Pos", "Eq", "J", "P", "V", "E", "D", "GM", "GS", "DG","Últimos 5 jogos"]];  // falta um elemento que é os últimos 5 jogos

  const data = [
    [
      [UpArrow,"position1"],
      "test",
      "test1",
      "test2",
      "test3",
      "test4",
      "test5",
      "test6",
      "test7",
      "test8",
      "test9"
    ],
    [
      [DownArrow,"position2"],
      "test10",
      "test11",
      "test12",
      "test13",
      "test14",
      "test15",
      "test16",
      "test17",
      "test18",
      "test19"
    ],
    [
      [DoubleDownArrow,"position3"],
      "test20",
      "test21",
      "test22",
      "test23",
      "test24",
      "test25",
      "test26",
      "test27",
      "test28",
      "test29"
    ],
  ];

  return (
    <>
      <Table stickyHeader className={"text-center mb-5 tablecss"}>
        {header.map((row) => {
          return (
            <tr>
              {row.map((col) => (
                <td>{col}</td>
              ))}
            </tr>
          );
        })}
        {data.map((row) => {
          return (
            <tr>
              {row.map((col) => (
                <td>{col}</td>
              ))}
            </tr>
          );
        })}
      </Table>
      {/* <div className="legend">
        <h4>Legenda:</h4>
        <ul>
            <li><p><span>Pos-</span> Posição</p></li>
            <li><p><span>Eq-</span> Equipa</p></li>
            <li><p><span>P-</span> Pontos</p></li>
            <li><p><span>V-</span> Vitórias</p></li>
            <li><p><span>E-</span> Empates</p></li>
            <li><p><span>D-</span> Derrotas</p></li>
            <li><p><span>GM-</span> Golos Marcados</p></li>
            <li><p><span>GS-</span> Golos Sofridos</p></li>
            <li><p><span>DG-</span> Divisão do Grupo</p></li>
        </ul>
      </div> */}
    </>
  );
};

 export default SportTable;
