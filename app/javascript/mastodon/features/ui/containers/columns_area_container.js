import { connect } from 'react-redux';

import ColumnsArea from '../components/columns_area';

const mapStateToProps = state => ({
  columns: state.getIn(['settings', 'columns']),
  isModalOpen: !!state.get('modal').modalType,
  membership: state.getIn(['compose', 'membership']),
});

export default connect(mapStateToProps, null, null, { forwardRef: true })(ColumnsArea);
