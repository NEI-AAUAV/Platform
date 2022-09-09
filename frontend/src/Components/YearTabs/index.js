import { styled } from '@mui/material/styles';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';


const YearTab = styled((props) => <Tab disableRipple {...props} />)({
    textTransform: 'none',
    fontFamily: "inherit",
    fontWeight: "inherit",
    fontSize: "inherit",
    color: "var(--text-primary)",

    '&:hover': {
        color: 'rgb(78, 156, 54)',
        fontWeight: "400",
    },
    '&.Mui-selected': {
        color: "var(--text-primary)",
        fontWeight: "400",
    },
    '&.Mui-focusVisible': {
        backgroundColor: 'rgba(100, 95, 228, 0.32)',
    },
    borderBottom: "rgb(180, 178, 178) 1px solid",
    margin: 0,
    padding: "0 15px",
    maxWidth: "unset",
    minWidth: "unset",
});


const YearTabs = styled(({ years, value, onChange, ...props }) => (
    <Tabs
        value={years?.indexOf(value || years[0])}
        onChange={(e, v) => onChange(years[v])}
        variant="scrollable"
        scrollButtons
        TabIndicatorProps={{ children: <span className="MuiTabs-indicatorSpan" /> }}
        {...props}
    >
        {years?.map((value) => <YearTab key={value} label={value} />)}
    </Tabs>
))({
    '& .MuiTabs-scrollButtons': {
        backgroundColor: 'transparent',
        color: "#363636",
        alignSelf: "center",
        height: "40px",
        borderRadius: "50%",
    },
    '& .MuiTabs-indicator': {
        display: 'flex',
        justifyContent: 'center',
        backgroundColor: 'transparent',
    },
    '& .MuiTabs-indicatorSpan': {
        width: "10px",
        height: "10px",
        transform: "rotate(45deg)",
        backgroundColor: "var(--background)",
        display: "inline-block",
        position: "absolute",
        borderTop: "rgb(180, 178, 178) 1px solid",
        borderLeft: "rgb(180, 178, 178) 1px solid",
        bottom: -5,
        left: "45%",
    },
});


export default YearTabs;
